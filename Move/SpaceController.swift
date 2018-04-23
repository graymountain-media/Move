//
//  SpaceController.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class SpaceController {
    
    static let shared = SpaceController()
    var spaces: [Space] = []
    
    //create space
    func createSpace(withName name: String){
        let newSpace = Space(name: name)
        spaces.append(newSpace)
    }
    
    //update space
    func update(space: Space, withName newName: String){
        space.name = newName
    }
    
    //delete space
    func delete(space: Space){
        guard let index = spaces.index(of: space) else {
            print("Error deleting space")
            return
        }
        spaces.remove(at: index)
    }
    
    //create Room
    func createRoom(withName name: String, inSpace space: Space ){
        let newRoom = Room(name: name, space: space)
        space.rooms.append(newRoom)
    }
    
    //delete Room
    func delete(room: Room, inSpace space: Space){
        guard let index = space.index(of: room) else {
            print("Error deleting room")
            return
        }
        space.rooms.remove(at: index)
    }
}
