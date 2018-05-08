//
//  Item.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
//    var name: String
//    var box: Box
    
    convenience init(name: String, box: Box, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.box = box
        self.isFragile = false
    }
    
//    static func == (lhs: Item, rhs: Item) -> Bool {
//        return (lhs.name == rhs.name && lhs.box == rhs.box)
//    }
}
