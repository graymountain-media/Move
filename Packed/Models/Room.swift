//
//  Room.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation
import CoreData

extension Room {
    
    convenience init(name: String, place: Place, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = name
        self.boxes = []
        self.place = place
        self.boxCount = 01
        self.id = UUID().uuidString
    }
 
    convenience init(dict: NSDictionary, place: Place, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = dict["name"] as? String ?? "Default Room"
        self.boxes = []
        self.place = place
        self.boxCount = 01
        self.id = dict["id"] as? String ?? UUID().uuidString
    }
    
}
