//
//  Box.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class Box: Equatable {
    
    var name: String
//    let QRID = String
    var items: [Item]
    var room: Room
    
    init(name: String, room: Room){
        self.name = name
        self.items = []
        self.room = room
    }
    
    static func == (lhs: Box, rhs: Box) -> Bool {
        return (lhs.name == rhs.name && lhs.items == rhs.items && lhs.room == rhs.room)
    }
}
