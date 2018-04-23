//
//  Item.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class Item: Equatable {
    
    var name: String
    var box: Box
    
    init(name: String, box: Box) {
        self.name = name
        self.box = box
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return (lhs.name == rhs.name && lhs.box == rhs.box)
    }
}
