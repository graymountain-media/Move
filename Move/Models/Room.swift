//
//  Room.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class Room {
    let name: String
    let boxes: [Box]
    let space: Space
    
    init(name: String, space: Space){
        self.name = name
        self.boxes = []
        self.space = space
    }
}
