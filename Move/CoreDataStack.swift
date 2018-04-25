//
//  CoreDataStack.swift
//  Move
//
//  Created by Jake Gray on 4/25/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoveDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Error loaing from CoreData: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    
}
