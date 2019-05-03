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
    func getProducts() {
        let getProductsURL = URL(string: restAPIURL + "/products")
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask
    
        
        let urlRequest = URLRequest(url: getProductsURL!)
        
        dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    
                    print(json)
                }

            
                
            }
            
        }
        
        dataTask.resume()

    }
    
    func getHistoricRates () {
        let getHistoricRatesURL = restAPIURL + "/products/<product-id>/candles"
        // Get list of products, generate historic rates for them
        
        
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
