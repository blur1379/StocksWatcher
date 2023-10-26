//
//  ViewController.swift
//  StocksWatcher
//
//  Created by Mohammad Blur on 10/25/23.
//

import UIKit

class ViewController: UIViewController{
    var socketViewModel = SocketViewModel()
    @IBOutlet weak var stocksTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stocksTableView.dataSource = self
        stocksTableView.delegate = self
        stocksTableView.register(SocketTableViewCell.nib(), forCellReuseIdentifier: SocketTableViewCell.identifier)
        socketViewModel.$tickerData.sink { [weak self] _ in
            self?.stocksTableView.reloadData()
        }.store(in: &socketViewModel.cancellables)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketViewModel.disconnect()
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        socketViewModel.tickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocketTableViewCell.identifier, for: indexPath) as! SocketTableViewCell
            cell.configer(with: socketViewModel.tickerData[indexPath.row])
            return cell
    }
    
}


