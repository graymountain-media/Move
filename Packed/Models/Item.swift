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
    
    convenience init(name: String, box: Box, isFragile: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.box = box
        self.isFragile = isFragile
        self.id = UUID().uuidString
    }
    
    convenience init(withDict dict: NSDictionary, inBox box: Box, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = dict["name"] as? String ?? "Default Item"
        self.box = box
        self.isFragile = dict["isFragile"] as? Bool ?? false
        self.id = dict["id"] as? String ?? UUID().uuidString
    }

}
