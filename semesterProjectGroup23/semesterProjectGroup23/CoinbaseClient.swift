//
//  CoinbaseClient.swift
//  semesterProjectGroup23
//
//  Created by Terry Kim on 5/3/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import Foundation
import Starscream

class CoinbaseClient: WebSocketDelegate {
    // IMPORTANT: Create apikey.txt in semesterProjectGroup23 and add your API key to the first line.
    // You might need to drag the file into the project outline on the left side to make sure it's added
    // as a dependency
    
    //you actually don't need the api key for a lot of these requests b/c we're not trading
    
    var socket: WebSocket!
    var connectedToStream: Bool
    let apiKey: String
    let restAPIURL: String
    
    init () {
        connectedToStream = false
        restAPIURL = "https://api.pro.coinbase.com"
        
        let path = Bundle.main.path(forResource: "apikey", ofType: "txt")
        var keyFromFile = ""
        do {
            keyFromFile = try String(contentsOfFile: path!, encoding: .ascii)
            keyFromFile = keyFromFile.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            print("Error: \(error)")
        }
        apiKey = keyFromFile
    }
    
    // REST API CALLS
    func getProducts(completion: @escaping ([Product]) -> ()) {
        let getProductsURL = URL(string: restAPIURL + "/products")
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask
        let urlRequest = URLRequest(url: getProductsURL!)
        var productArray:[Product] = []
        
        dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    //print(json)
                    
                    for case let result as [String:Any] in json! {
                        if let product = Product(json: result)  {
                            if (product.quote_currency == "USD") {
                                productArray.append(product)
                            }
  
                        }
                    }
                    
                    completion(productArray)
                }
            }
            
            
        }
        
        dataTask.resume()
    }
    
    func getHistoricRates (id: String, interval: String) {
        // Historical rate data may be incomplete. No data is published for intervals where there are no ticks.
        
        let getHistoricRatesURL = URL(string: restAPIURL + "/products/" + id + "/candles")
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask
        
        var urlRequest = URLRequest(url: getHistoricRatesURL!)
        var historicRateArray:[ProductRate] = []
        urlRequest.addValue("2018-07-10t12:00:00", forHTTPHeaderField: "start")
        urlRequest.addValue("2018-07-15t12:00:00", forHTTPHeaderField: "end")
        urlRequest.addValue(interval, forHTTPHeaderField: "granularity")
        print("test")
        dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            print("hi")
            if error == nil {
                if let data = data {
                    var json: Any?
                    json = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let respdict = json as? [String : Any] {
                        print ("string arr")
                        print (respdict)
                    }
                        
                    else if let respArr = json as? [Any]{
                        print ("arr")
                        //print (respArr)
                        for case let result as [Any] in respArr {
                            if let productRate = ProductRate(json: result, id: id, interval: interval)  {
                                historicRateArray.append(productRate)
                                
                                print(productRate)
                            }
                        }
                    }
                        
                    else if let stringRespt = String(data: data, encoding: .utf8){
                        print ("string")
                        print (stringRespt)
                    }
                    
                }
            }
            
            
        }
        
        dataTask.resume()
        
        
        
        
    }
    
    
    
    
    // STREAMS
    func connectToStream() {
        if connectedToStream {
            return
        }
        print("Connecting to stream")
        let webSocketFeedURL = "wss://ws-feed.pro.coinbase.com"
        var request = URLRequest(url: URL(string: webSocketFeedURL)!)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self

        socket.connect()

    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Coinbase websocket is connected")

        let body: [String: Any] =
            [
                "type": "subscribe",
                "product_ids": [
                    "ETH-USD"
                ],
                "channels": [
                    "level2",
                    "heartbeat",
                    [
                        "name": "ticker",
                        "product_ids": [
                            "ETH-BTC"
                        ]
                    ]
                ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
        socket.write(string: jsonString, completion: {
            print("Subscribing to  Ticker")
            
        })
 
        
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        //print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}

enum Serialization: Error {
    case missing(String)
    case invalid(String,Any)
}

struct Product {
    let id: String
    let base_currency: String
    let quote_currency: String
    let display_name: String
}

extension Product {
    init?(json: [String:Any]) {
        guard
            let id = json["id"] as? String,
            let base_currency = json["base_currency"] as? String,
            let quote_currency = json["quote_currency"] as? String,
            let display_name = json["display_name"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.base_currency = base_currency
        self.quote_currency = quote_currency
        self.display_name = display_name
    }
}

struct ProductRate {
    let id: String
    let interval: String
    let time: Int
    let low: Double
    let high: Double
    let open: Double
    let close: Double
    let volume: Double
}

extension ProductRate {
    init?(json: [Any], id: String, interval: String) {
        let test = json[0] as? Int
        
        guard
            let time = json[0] as? Int,
            let low = json[1] as? Double,
            let high = json[2] as? Double,
            let open = json[3] as? Double,
            let close = json[4] as? Double,
            let volume = json[5] as? Double
            else {
                return nil
        }
        
        self.id = id
        self.interval = interval
        self.time = time
        self.low = low
        self.high = high
        self.open = open
        self.close = close
        self.volume = volume
    }
}
