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
    var coinID: String
    var curPrice: String
    
    
    
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
        coinID = ""
        curPrice = "1234.56"
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
    
    func get24hrStats (id:String ,completion: @escaping ([String:String]) -> ()) {
        let get24hrStatsURL = URL(string: restAPIURL + "/products/" + id + "/stats")
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask
        
        let urlRequest = URLRequest(url: get24hrStatsURL!)
        
        dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                if let data = data {
                    var json: Any?

                    json = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let respdict = json as? [String : Any] {
                        print ("string arr22")
                        print (respdict)
                        var retArray:[String:String] = [:]
                        
                        
                        if var open = respdict["open"] as? String {
                            //open.remove(at: open.startIndex)
                            let openDouble = Double(open)!
                            let openFormated = String(format: "$%.02f", openDouble)
                            retArray["open"] = openFormated
                        }
                        
                        if var last = respdict["last"] as? String {
                            //last.remove(at: last.startIndex)
                            let lastDouble = Double(last)!
                            let lastFormated = String(format: "$%.02f", lastDouble)
                            retArray["last"] = lastFormated
                        }
                        
                        if var low = respdict["low"] as? String {
                            //low.remove(at: low.startIndex)
                            let lowDouble = Double(low)!
                            let lowFormated = String(format: "$%.02f", lowDouble)
                            retArray["low"] = lowFormated
                        }
                        
                        if var high = respdict["high"] as? String {
                            //high.remove(at: high.startIndex)
                            let highDouble = Double(high)!
                            let highFormated = String(format: "$%.02f", highDouble)
                            retArray["high"] = highFormated
                        }
                        
                        if var volume_30day = respdict["volume_30day"] as? String {
                            //volume_30day.remove(at: volume_30day.startIndex)
                            let volDouble = Double(volume_30day)!
                            let volFormated = String(format: "$%.02f", volDouble)
                            retArray["volume_30day"] = volFormated
                        }
                        
                        if var volume = respdict["volume"] as? String {
                            //volume.remove(at: volume.startIndex)
                            let volDouble = Double(volume)!
                            let volFormated = String(format: "$%.02f", volDouble)
                            retArray["volume"] = volFormated
                        }

                        completion(retArray)
                        
                    }
                        
                    else if let respArr = json as? [Any]{
                        print ("arr")
                        print (respArr)

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
    
    func getHistoricRates (id: String, startDate: String, interval: String, completion: @escaping ([ProductRate]) -> ()) {
        // Historical rate data may be incomplete. No data is published for intervals where there are no ticks.
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd't'hh:mm:ss"
		let currDate = dateFormatter.string(from: Date())
		print("this is the current date: " + currDate)
		
        //let getHistoricRatesURL =
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.pro.coinbase.com"
        urlComponents.path = "/products/" + id + "/candles"
        urlComponents.queryItems = [
            URLQueryItem(name: "start", value: startDate),
            URLQueryItem(name: "end", value: currDate),
            URLQueryItem(name: "granularity", value: interval)
        ]
        
        let getHistoricRatesURL =  urlComponents.url
        print (getHistoricRatesURL!)
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask
        
        var urlRequest = URLRequest(url: getHistoricRatesURL!)
        var historicRateArray:[ProductRate] = []
        
        
        dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            
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
                        
                        for case let result as [Any] in respArr {
                            if let productRate = ProductRate(json: result, id: id, interval: interval)  {
                                historicRateArray.append(productRate)
                                
                    
                            }
                        }
                        
                        historicRateArray.reverse()
                        //print (historicRateArray)
                        completion(historicRateArray)
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
    
    func convertToCurrency () {
        
    }
    
    
    
    // STREAMS
    func connectToStream(coinID: String) {
        if connectedToStream {
            return
        }
        self.coinID = coinID
        
        print("Connecting to stream " + coinID)
        let webSocketFeedURL = "wss://ws-feed.pro.coinbase.com"
        var request = URLRequest(url: URL(string: webSocketFeedURL)!)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self

        socket.connect()

    }
    
    func disconnectFromStream() {
        if (connectedToStream) {
            socket.disconnect()
            connectedToStream = false
        }
        
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Coinbase websocket is connected")
        connectedToStream = true
        let body: [String: Any] =
            [
                "type": "subscribe",
                "product_ids": [
                    coinID
                ],
                "channels": [
                    "level2",
                    "heartbeat",
                    [
                        "name": "ticker",
                        "product_ids": [
                            coinID
                        ]
                    ]
                ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
        socket.write(string: jsonString, completion: {
            print("Subscribing to  Ticker " + self.coinID)
            
        })
 
        
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        connectedToStream = false
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
        let data = text.data(using: .utf8)!
        
        var json: Any?
        json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let respdict = json as? [String : Any] {
            //print ("string arr")
            if let changesAry = respdict["changes"] as? [[String]] {
                curPrice = changesAry[0][1]
                //curPrice.remove(at: curPrice.startIndex)

            }
            
            
        } else {
            print ("something wrong was returned")
        }
        
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    func getCurrentPrice () -> String {
        let doubleString = Double(curPrice)!
        let returnPrice = String(format: "$%.02f", doubleString)
        //print (returnPrice)
        return returnPrice
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
