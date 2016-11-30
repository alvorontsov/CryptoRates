//
//  DatabaseManager.swift
//  Crypto rates
//
//  Created by Alexander on 15/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    class var sharedAdapter: DatabaseManager {
        struct Singleton {
            static let sharedAdapter = DatabaseManager()
        }
        
        return Singleton.sharedAdapter
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    fileprivate override init() {
        let modelURL = Bundle.main
            .url(forResource: "Model",
                            withExtension: "momd")!
        model = NSManagedObjectModel(
            contentsOf: modelURL)!
        
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask).last as URL?
        let storeURL = docsURL!.appendingPathComponent("Model.sqlite")
        coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: model)
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        super.init()
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
    }
    
    func getPairs()->[Pair?] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pair")
        request.fetchLimit = 100
        var result : [Pair?] = []
        do {
            result = try context.fetch(request) as! [Pair?]
        }
        catch _ {
            print("error")
        }
        let arrayCopy = result
        return arrayCopy
    }
    
    func addPair(_ firstCurrency : String , secondCurrency : String , lastPrice : NSNumber , percentChange : NSNumber , lowest : NSNumber , highest : NSNumber) {
        let newPair = NSEntityDescription.insertNewObject(forEntityName: "Pair", into: context) as! Pair
        (newPair.firstCurrency , newPair.secondCurrency , newPair.lastPrice , newPair.percentChange , newPair.lowest , newPair.highest) = (firstCurrency , secondCurrency , lastPrice , percentChange , lowest , highest)
        save()
    }
    
    func deletePairs() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pair")
        do {
            let fetchResults = try context.fetch(request) as! [NSManagedObject?]
            
            
            if let managedObjects = fetchResults as? [NSManagedObject] {
                for object in managedObjects {
                    context.delete(object)
                }
            }
            print("Deleting CoreData")
            save()

        }
        catch _ {
            print("error deleting")
        }
       
    }
    


}
