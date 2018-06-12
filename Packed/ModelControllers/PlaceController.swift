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
            PlaceController.createRoom(withName: newPlace.name!, inPlace: newPlace)
        }
    }
    
    static func createPlace(withDict dict: NSDictionary){
        let _ = Place(dict: dict)
        
        saveData()
        
//        if !isHome{
//            PlaceController.createRoom(withName: newPlace.name!, inPlace: newPlace)
//        }
        
    }
    
    //update place
    static func update(place: Place, withName newName: String, isHome newIsHome: Bool){
        place.name = newName
        place.isHome = newIsHome
        if place.isShared{
            FirebaseDataManager.update(place: place, withName: newName)
        }
        saveData()
    }
    
    //delete place
    static func delete(place: Place){
        if place.isShared {
            FirebaseDataManager.delete(place: place)
        }
        place.managedObjectContext?.delete(place)
        
        if place.isShared {
            FirebaseDataManager.delete(place: place)
        }
        
        saveData()
    }
    
    //create Room
    static func createRoom(withName name: String, inPlace place: Place ){
        let room = Room(name: name, place: place)
        if place.isShared {
            FirebaseDataManager.create(room: room)
        }
        saveData()
    }
    
    static func createRoom(withDict dict: NSDictionary, inPlace place: Place ){
        let _ = Room(dict: dict, place: place)
        saveData()
    }
    
    //delete Room
    static func delete(room: Room){
        if (room.place?.isShared)! {
            FirebaseDataManager.delete(room: room)
        }
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
