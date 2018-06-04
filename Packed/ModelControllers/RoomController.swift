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
        if (room.place?.isShared)! {
            FirebaseDataManager.update(room: room, withName: newName)
        }
    }
    
    //create Box
    static func createBox(withName name: String, inRoom room: Room ){
        let newBox = Box(name: name, room: room)
        if (newBox.room?.place?.isShared)! {
            FirebaseDataManager.create(box: newBox)
        }
        saveData()
    }
    
    //delete Box
    static func delete(box: Box){
        if (box.room?.place?.isShared)! {
            FirebaseDataManager.delete(box: box)
        }
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
