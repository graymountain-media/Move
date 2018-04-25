//
//  Space.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation
import CoreData

extension Space{
    
//    var name: String
//    var rooms: [Room]
    
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
        self.rooms = []
    }
    
//    static func == (lhs: Space, rhs: Space) -> Bool {
//        return (lhs.name == rhs.name && rhs.rooms == rhs.rooms)
//    }
    
}
