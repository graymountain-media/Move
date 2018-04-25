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
    
//    var name: String
//    var boxes: [Box]
//    var space: Space
    
    convenience init(name: String, space: Space, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = name
        self.boxes = []
        self.space = space
    }
    
//    static func == (lhs: Room, rhs: Room) -> Bool {
//        return (lhs.name == rhs.name && lhs.boxes == rhs.boxes && lhs.space == rhs.space)
//    }
    
}
