//
//  FirebaseDataController.swift
//  Packed
//
//  Created by Jake Gray on 6/4/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirebaseDataManager {
    
    // MARK: - Places
    
    static func share(place: Place) {
        let placesRef = ref.child("places").child(place.id!)
        
        let values: [String:Any] = ["name" : place.name ?? "Default Name", "owner" : place.owner ?? "Default Owner", "isHome" : place.isHome]
        
        placesRef.updateChildValues(values)
        place.isShared = true
    }
    
    static func update(place: Place, withName name: String) {
        ref.child("places").child(place.id!).child("name").setValue(name)
    }
    
    static func delete(place: Place) {
        for room in place.rooms! {
            delete(room: room as! Room)
        }
        ref.child("places").child(place.id!).removeValue()
    }
    
    // MARK: - Rooms
    
    static func create(room: Room) {
        let roomsRef = ref.child("rooms").child((room.place?.id)!).child((room.id?.uuidString)!)
        
        let values: [String:Any] = ["name" : room.name ?? "Default Name"]
        
        roomsRef.updateChildValues(values)
    }
    
    static func update(room: Room, withName name: String) {
        ref.child("rooms").child((room.place?.id)!).child((room.id?.uuidString)!).child("name").setValue(name)
    }
    
    static func delete(room: Room) {
        for box in room.boxes!{
            delete(box: box as! Box)
        }
        ref.child("rooms").child((room.place?.id)!).child((room.id?.uuidString)!).removeValue()
    }
    
    // MARK: - Boxes
    
    static func create(box: Box) {
        let boxesRef = ref.child("boxes").child((box.room?.id?.uuidString)!).child((box.id?.uuidString)!)
        
        let values: [String:Any] = ["name" : box.name ?? "Default Name"]
        
        boxesRef.updateChildValues(values)
    }
    
    static func update(box: Box, withName name: String) {
        ref.child("boxes").child((box.room?.id?.uuidString)!).child((box.id?.uuidString)!).child("name").setValue(name)
        ref.child("boxes").child((box.room?.id?.uuidString)!).child((box.id?.uuidString)!).child("isFragile").setValue(box.isFragile)
    }
    
    static func delete(box: Box) {
        for item in box.items! {
            delete(item: item as! Item)
        }
        ref.child("boxes").child((box.room?.id?.uuidString)!).child((box.id?.uuidString)!).removeValue()
    }
    
    // MARK: - Items
    
    static func create(item: Item) {
        let itemsRef = ref.child("items").child((item.box?.id?.uuidString)!).child((item.id?.uuidString)!)
        
        let values: [String:Any] = ["name" : item.name ?? "Default Name"]
        
        itemsRef.updateChildValues(values)
        
        let detailValues: [String:Any] = ["name" : item.name!, "isFragile": item.isFragile, "box" : (item.box?.id?.uuidString)!]
        ref.child("item_details").child((item.id?.uuidString)!).updateChildValues(detailValues)
    }
    
    static func update(item: Item, withName name: String) {
        ref.child("items").child((item.box?.id?.uuidString)!).child((item.id?.uuidString)!).child("name").setValue(name)
        let values: [String:Any] = ["name" : name, "isFragile": item.isFragile, "box" : (item.box?.id?.uuidString)!]
        ref.child("item_details").child((item.id?.uuidString)!).updateChildValues(values)
    }
    
    static func delete(item: Item) {
        ref.child("items").child((item.box?.id?.uuidString)!).child((item.id?.uuidString)!).removeValue()
        ref.child("item_details").child((item.id?.uuidString)!).removeValue()
    }
    
    // MARK: - Data Processing
    
    func processNewPlace(dict: [String:Any], sender: PlaceViewController) {
        var owner: String = ""
        var newPlaceDict: NSDictionary = [:]
        
        for _ in 0...dict.count {
            guard let placeID = dict.first?.value as? String else {
                print("Error decoding place id")
                return
            }
            
            for place in sender.PlacesFetchedResultsController.fetchedObjects! {
                if place.id == placeID {
                    print("place already exists, moving on")
                    return
                }
            }
            
            ref.child("places").child(placeID).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                let dict = snapshot.value as? NSDictionary ?? [:]
                let ownerID = dict["owner"] as! String
                newPlaceDict = dict
                
                ref.child("users").child(ownerID).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                    let dict = snapshot.value as? NSDictionary ?? [:]
                    owner = dict["name"] as? String ?? "User"
                    print("user dict: \(dict)")
                    newPlaceDict.setValue(owner, forKey: "ownerName")
                    newPlaceDict.setValue(placeID, forKey: "id")
                    
                    PlaceController.createPlace(withDict: newPlaceDict)
                }
                
                
                print(dict)
            }
        }
    }
}
