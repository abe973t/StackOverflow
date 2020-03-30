//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by mcs on 1/29/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import CoreData
import os.log

final class CoreDataFetchOps {
    private init() {}
    static let shared = CoreDataFetchOps()
    let context = CoreDataManager.shared.mainContext
    
    func fetchQuestion(ques: FavQuestion? = nil) -> [FavQuestion] {
        let fetchRequest: NSFetchRequest<FavQuestion> = FavQuestion.fetchRequest()
        
        if let question = ques, let questionURL = question.url {
            fetchRequest.predicate = NSPredicate(format: "url = %@", questionURL)
        }
        
        do {
            let ques = try context.fetch(fetchRequest)
            return ques
        } catch {
            os_log("Fetching objects from CoreData failed", error.localizedDescription)
        }
        
        return []
    }
}
