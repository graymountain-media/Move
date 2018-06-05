//
//  Place.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

extension Place{
    
//    var name: String
//    var rooms: [Room]
    
    convenience init(name: String, isHome: Bool, owner: String = "", context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
        self.rooms = []
        self.isHome = isHome
        self.isShared = false
        self.owner = owner
        self.id = UUID().uuidString
    }
    
    convenience init(dict: NSDictionary,context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = dict["name"] as? String
        self.rooms = []
        
        let isHomeValue = dict["isHome"] as? Int ?? 1
        if isHomeValue == 1 {
            self.isHome = true
        } else {
            self.isHome = false
        }
        
        self.isShared = true
        self.owner = dict["ownerName"] as? String ?? "User"
        self.id = dict["id"] as? String ?? ""
    }
    
//    static func == (lhs: Space, rhs: Space) -> Bool {
//        return (lhs.name == rhs.name && rhs.rooms == rhs.rooms)
//    }
    
}
