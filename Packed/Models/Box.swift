//
//  Box.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation
import CoreData

extension Box {
    
    convenience init(name: String, room: Room, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = name
        self.items = []
        self.room = room
        self.isFragile = false
        self.id = UUID().uuidString
    }
    
    convenience init(dict: NSDictionary, inRoom room: Room, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = dict["name"] as? String ?? "Default Box"
        self.items = []
        self.room = room
        self.isFragile = dict["isFragile"] as? Bool ?? false
        self.id = dict["id"] as? String ?? UUID().uuidString
    }
    
}
