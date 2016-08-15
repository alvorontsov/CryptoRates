//
//  CurrencyPair.swift
//  Crypto rates
//
//  Created by Alexander on 13/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit

class CurrencyPair: NSObject {
    
    var firstCurrency : String!
    var secondCurrency : String!
    var lastPrice : Double!
    var percentChange : Double!
    
    convenience init(firstCurrency : String , secondCurrency : String , lastPrice : Double , percentChange : Double!) {
        self.init()
        self.firstCurrency = firstCurrency
        self.secondCurrency = secondCurrency
        self.lastPrice = lastPrice
        self.percentChange = percentChange
    }
    
    func getCurrencyPairName() -> String {
        let str = firstCurrency + "/" + secondCurrency
        return str
    }
    
    


}
