//
//  Pair.swift
//  Crypto rates
//
//  Created by Alexander on 15/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import Foundation
import CoreData


class Pair: NSManagedObject {

    func getCurrencyPairName() -> String {
        let str = firstCurrency! + "/" + secondCurrency!
        return str
    }
    
    func set(_ firstCurrency: String, secondCurrency: String, lastPrice: NSNumber, percentChange: NSNumber , highest: NSNumber , lowest: NSNumber) {
        self.firstCurrency = firstCurrency
        self.secondCurrency = secondCurrency
        self.lastPrice = lastPrice
        self.percentChange = percentChange
        self.highest = highest
        self.lowest = lowest
    }
 
    
}
