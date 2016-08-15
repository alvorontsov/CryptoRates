//
//  ExtendedCurrencyTableViewCell.swift
//  Crypto rates
//
//  Created by Alexander on 08/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit

class ExtendedCurrencyTableViewCell: UITableViewCell {

    @IBOutlet var currencyPairLabel : UILabel!
    @IBOutlet var lastPriceLabel : UILabel!
    @IBOutlet var percentChangeLabel : UILabel!
    @IBOutlet var highestLabel : UILabel!
    @IBOutlet var lowestLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func linkPair(pair : CopyingPair) {
            self.currencyPairLabel.text = pair.getCurrencyPairName()
            self.lastPriceLabel.text = String(Double(round(pair.lastPrice!  * 100000000)/100000000))
            self.highestLabel.text = String(Double(round(pair.highest! * 100000000)/100000000))
            self.lowestLabel.text = String(Double(round(pair.lowest! * 100000000)/100000000))
            if (pair.percentChange! >= 0) {
                self.percentChangeLabel.text = String(Double(round(pair.percentChange! * 1000000)/1000000))
                self.percentChangeLabel.textColor = UIColor.greenColor()
            }
            else {
                self.percentChangeLabel.text = String(Double(round(pair.percentChange! * 1000000)/1000000))
                self.percentChangeLabel.textColor = UIColor.redColor()
            }
    }

}
