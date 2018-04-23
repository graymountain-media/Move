//
//  Space.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class Space {
    let name: String
    let rooms: [Room]
    
    init(name: String){
        self.name = name
        self.rooms = []
    }
}
