//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by mcs on 1/29/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import CoreData
import os.log

final class CoreDataManager {
    
    private init() {}
    static let shared = CoreDataManager()
    let dataModelName = "StackItUp"
    
    // can store up to 1000 records
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // > 1000 records
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        let description = NSPersistentStoreDescription()
                
        description.shouldMigrateStoreAutomatically = false
        description.shouldInferMappingModelAutomatically = false
        description.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(dataModelName + ".sqlite")
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else {
                os_log(.info, log: OSLog.coreData, "The CoreData container that persists was initialized at: %@", description.url?.absoluteString ?? "location not found")
            }
        })
        
        return container
    }()
    
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            os_log(.error, log: OSLog.coreData, "CoreData save failed, message: %@", error.localizedDescription)
        }
    }
    
    func fetchObjects<T>(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) -> [T] {
        do {
            return try context.fetch(fetchRequest)
        } catch {
            os_log(.error, log: OSLog.coreData, "Fetching objects from CoreData failed, message: %@", error.localizedDescription)
        }
        
        return []
    }
    
    func batchDelete(objects: [NSManagedObject], context: NSManagedObjectContext) {
        let objectIds: [NSManagedObjectID] = objects.map { $0.objectID }
        let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIds)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            os_log(.error, log: OSLog.coreData, "Deleting objects from CoreData failed, message: %@", error.localizedDescription)
        }
    }
}
