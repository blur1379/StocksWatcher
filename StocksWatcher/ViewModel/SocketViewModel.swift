//
//  SocketViewModel.swift
//  StocksWatcher
//
//  Created by Mohammad Blur on 10/26/23.
//

import Foundation
import Combine
class SocketViewModel: ObservableObject {
    @Published var tickerData = [TickerModel]()
    var soketManager = SocketManager.shared
    var cancellables = Set<AnyCancellable>()
    init() {
        soketManager.delegate = self
        soketManager.connect()
    }
    
    func disconnect() {
        soketManager.disconnect()
    }
    
}

extension SocketViewModel: WebSocketManagerDelegate {
    func didReceiveTickerData(_ data: [TickerModel]) {
        DispatchQueue.main.async {
            self.tickerData = data
        }
    }
}
