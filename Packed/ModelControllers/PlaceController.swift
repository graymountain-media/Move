//
//  PlaceController.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class PlaceController {
    
    
    //create place
    static func createPlace(withName name: String, isHome: Bool){
        let newPlace = Place(name: name, isHome: isHome)
        
        saveData()
        
        if !isHome{
            PlaceController.createRoom(withName: "Base Room", inPlace: newPlace)
        }
    }
    
    //update place
    static func update(place: Place, withName newName: String, isHome newIsHome: Bool){
        place.name = newName
        place.isHome = newIsHome
        saveData()
    }
    
    //delete place
    static func delete(place: Place){
        place.managedObjectContext?.delete(place)
        
        saveData()
    }
    
    //create Room
    static func createRoom(withName name: String, inPlace place: Place ){
        let newRoom = Room(name: name, place: place)
        print(newRoom)
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
