//
//  RoomController.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class RoomController {
    
    //Update Room
    static func update(room: Room, withName newName: String){
        room.name = newName
    }
    
    //create Box
    static func createBox(withName name: String, inRoom room: Room ){
        let _ = Box(name: name, room: room)
        saveData()
    }
    
    //delete Box
    static func delete(box: Box){
        box.managedObjectContext?.delete(box)
        
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
