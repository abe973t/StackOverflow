//
//  CoreDataDeleteOps.swift
//  CoreDataDemo
//
//  Created by mcs on 1/29/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import CoreData

final class CoreDataDeleteOps {
    
    private init() {}
    
    static let shared = CoreDataDeleteOps()
    let context = CoreDataManager.shared.mainContext

    func deleteQuestion(ques: FavQuestion? = nil) {
        let fetchRequest: NSFetchRequest<FavQuestion> = FavQuestion.fetchRequest()
        if let question = ques, let quesURLString = question.url {
            fetchRequest.predicate = NSPredicate(format: "url = %@", quesURLString)
        }
        
        let objects = CoreDataManager.shared.fetchObjects(fetchRequest: fetchRequest, context: context)
        if !objects.isEmpty {
            CoreDataManager.shared.batchDelete(objects: objects, context: context)
        }
        
        CoreDataManager.shared.batchDelete(objects: objects, context: context)
    }
}
