//
//  CoreDataSaveOps.swift
//  CoreDataDemo
//
//  Created by mcs on 1/29/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import CoreData
import os.log

final class CoreDataSaveOps {
    private init() {}
    static let shared = CoreDataSaveOps()
    let context = CoreDataManager.shared.mainContext
    let backgroundContext = CoreDataManager.shared.backgroundContext
    
    func saveQuestion(ques: FavQuestion) {
        var message = FavQuestion(context: context)
        
        message = ques
        
        do {
            try context.save()
        } catch {
            //post log
            print(error.localizedDescription)
        }
    }
    
    func saveMessages(msgArr: [FavQuestion]) {
        for message in msgArr {
            var msg = FavQuestion(context: context)
            
            msg = message
            
            backgroundContext.object(with: msg.objectID)
        }
        
        CoreDataManager.shared.saveContext(context: backgroundContext)
    }
}
