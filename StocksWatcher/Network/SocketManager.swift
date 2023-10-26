//
//  SocketManager.swift
//  StocksWatcher
//
//  Created by Mohammad Blur on 10/25/23.
//

import Foundation

protocol SocketManagerPorotocol{
    func connect()
    func disconnect()
    func receiveMessage()
    func sendMessage(text: String)
    func sendData(data: Data)
    func ping()
    func schaduleNextPing()
    func parseMessage(message:String)
    func parseMesage(data: Data)
}

protocol WebSocketManagerDelegate: AnyObject {
    func didReceiveTickerData(_ data: [TickerModel])
}

class SocketManager : SocketManagerPorotocol {
    
    static let shared = SocketManager()
    
    var delegate: WebSocketManagerDelegate?
    
    private init() {}
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "wss://fstream.binance.com/ws/!ticker@arr")!)
        webSocketTask?.resume()
        subscribeToStream()
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func subscribeToStream(){
        let message = URLSessionWebSocketTask.Message.string("{\"method\": \"SUBSCRIBE\",\"params\":[\"!ticker@arr\"],\"id\": 1}")
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error in sending message: \(error)")
            }
        }
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.parseMessage(message: text)
                case .data(let data):
                    self?.parseMesage(data: data)
                @unknown default:
                    fatalError()
                }
                self?.receiveMessage()
            }
        }
    }
    
    func sendMessage(text : String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error in sending message: \(error)")
            }
        }
    }
    
    func sendData(data: Data) {
        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error in sending data: \(error)")
            }
        }
    }
    
    func ping() {
        webSocketTask?.sendPing { error in
            if let error = error {
                print("Error in sending ping: \(error)")
            }
            self.schaduleNextPing()
        }
    }
    func schaduleNextPing(){
        DispatchQueue.global().asyncAfter(deadline: .now() + 15) { [weak self] in
            self?.ping()
        }
    }
    
    func parseMesage(data: Data){
        let decoder = JSONDecoder()
        do {
            let tickerData = try decoder.decode([TickerModel].self, from: data)
            delegate?.didReceiveTickerData(tickerData)
        } catch {
            print(error)
        }
    }
    
    func parseMessage(message:String){
        let decoder = JSONDecoder()
        do {
            let tickerData = try decoder.decode([TickerModel].self, from: message.data(using: .utf8)!)
            delegate?.didReceiveTickerData(tickerData)
        } catch {
            print(error)
        }
    }
    
}

