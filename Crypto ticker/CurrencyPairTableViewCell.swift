//
//  CurrencyPairTableViewCell.swift
//  Crypto rates
//
//  Created by Alexander on 13/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit

class CurrencyPairTableViewCell: UITableViewCell {
    
    @IBOutlet var currencyPairLabel : UILabel!
    @IBOutlet var lastPriceLabel : UILabel!
    @IBOutlet var percentChangeLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func linkPair(pair : CopyingPair) {
        self.currencyPairLabel.text = pair.getCurrencyPairName()
        if (pair.firstCurrency == "XEM") {
            self.lastPriceLabel.text = String(Double(pair.lastPrice))
        }
        else {
            self.lastPriceLabel.text = String(Double(round(pair.lastPrice  * 100000)/100000))
        }
        
        if (pair.percentChange >= 0) {
            self.percentChangeLabel.text = "+" + String(Double(round(pair.percentChange * 1000)/1000))
            self.percentChangeLabel.textColor = UIColor.greenColor()
        }
        else {
            self.percentChangeLabel.text = String(Double(round(pair.percentChange * 1000)/1000))
            self.percentChangeLabel.textColor = UIColor.redColor()
        }
    }
    
    


}
