//
//  Pair+CoreDataProperties.swift
//  Crypto rates
//
//  Created by Alexander on 15/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pair {

    @NSManaged var firstCurrency: String?
    @NSManaged var secondCurrency: String?
    @NSManaged var lastPrice: NSNumber?
    @NSManaged var percentChange: NSNumber?
    @NSManaged var lowest: NSNumber?
    @NSManaged var highest: NSNumber?

}
