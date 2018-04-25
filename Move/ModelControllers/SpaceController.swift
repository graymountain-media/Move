//
//  SpaceController.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class SpaceController {
    
//    static let shared = SpaceController()
//    var spaces: [Space] = []
    
    //create space
    static func createSpace(withName name: String){
        let _ = Space(name: name)
        saveData()
    }
    
    //update space
    static func update(space: Space, withName newName: String){
        space.name = newName
    }
    
    //delete space
    static func delete(space: Space){
        space.managedObjectContext?.delete(space)
        
        saveData()
    }
    
    //create Room
    static func createRoom(withName name: String, inSpace space: Space ){
        let _ = Room(name: name, space: space)
        saveData()
    }
    
    //delete Room
    static func delete(room: Room){
        room.managedObjectContext?.delete(room)
        
        saveData()
    }
    
    private static func saveData(){
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}
