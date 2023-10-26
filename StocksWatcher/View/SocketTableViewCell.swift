//
//  SocketTableViewCell.swift
//  StocksWatcher
//
//  Created by Mohammad Blur on 10/26/23.
//

import UIKit

class SocketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var percent: UILabel!
    
    static let identifier = "SocketTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "SocketTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configer(with model: TickerModel){
        self.name.text = model.s
        self.price.text = model.c
        self.percent.text = model.P
        self.percent.textColor = Double(model.P) ?? 0 > 0 ? UIColor.green : UIColor.red
    }
    
}
