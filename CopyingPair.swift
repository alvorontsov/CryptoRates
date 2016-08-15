//
//  CopyingPair.swift
//  Crypto rates
//
//  Created by Alexander on 15/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit

class CopyingPair: NSObject {
    
    var firstCurrency : String!
    var secondCurrency : String!
    var lastPrice : Double!
    var percentChange : Double!
    var lowest : Double!
    var highest : Double!
    
    convenience init (pair : Pair) {
        self.init()
        self.firstCurrency = pair.firstCurrency!.copy() as! String
        self.secondCurrency = pair.secondCurrency!.copy() as! String
        self.lastPrice = pair.lastPrice!.copy() as! Double
        self.percentChange = pair.percentChange!.copy() as! Double
        self.lowest = pair.lowest!.copy() as! Double
        self.highest = pair.highest!.copy() as! Double
    }
    
    func getCurrencyPairName() -> String {
        let str = firstCurrency! + "/" + secondCurrency!
        return str
    }

}
