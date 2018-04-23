//
//  Box.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class Box {
    let name: String
//    let QRID = String
    let items: [Item]
    let room: Room
    
    let init(name: String, room: Room){
        self.name = name
        self.items = []
        self.room = room
    }
}
