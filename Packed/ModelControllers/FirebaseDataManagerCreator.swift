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
    
    // MARK: - Place Creation
    
    static func share(place: Place, toUser user: String) {
        let placesRef = ref.child("places").child(place.id!)
        
        let values: [String:Any] = ["name" : place.name ?? "Default Name", "owner" : place.owner ?? "Default Owner", "isHome" : place.isHome, "id" : place.id!]
        
        placesRef.updateChildValues(values)
        place.isShared = true
        
        ref.child("shared").child(user).child(place.id!).updateChildValues(["name" : place.name!, "id" : place.id!])
    }
    
    static func update(place: Place, withName name: String) {
        ref.child("places").child(place.id!).child("name").setValue(name)
    }
    
    // MARK: - Room Creation
    
    static func create(room: Room) {
        let roomsRef = ref.child("rooms").child((room.place?.id)!).child(room.id!)
        
        let values: [String:Any] = ["name" : room.name ?? "Default Name", "id" : room.id!]
        
        roomsRef.updateChildValues(values)
    }
    
    static func update(room: Room, withName name: String) {
        ref.child("rooms").child((room.place?.id)!).child(room.id!).child("name").setValue(name)
    }
    
    // MARK: - Box Creation
    
    static func create(box: Box) {
        let boxesRef = ref.child("boxes").child((box.room?.id)!).child(box.id!)
        
        let values: [String:Any] = ["name" : box.name ?? "Default Name", "id" : box.id!]
        
        boxesRef.updateChildValues(values)
    }
    
    static func update(box: Box, withName name: String) {
        ref.child("boxes").child((box.room?.id)!).child(box.id!).child("name").setValue(name)
        ref.child("boxes").child((box.room?.id)!).child(box.id!).child("isFragile").setValue(box.isFragile)
    }
    
    // MARK: - Item Creation
    
    static func create(item: Item) {
        let itemsRef = ref.child("items").child((item.box?.id)!).child(item.id!)
        
        let values: [String:Any] = ["name" : item.name ?? "Default Name", "id" : item.id!]
        
        itemsRef.updateChildValues(values)
        
        let detailValues: [String:Any] = ["name" : item.name!, "isFragile": item.isFragile, "box" : (item.box?.id)!]
        ref.child("item_details").child(item.id!).updateChildValues(detailValues)
    }
    
    static func update(item: Item, withName name: String) {
        ref.child("items").child((item.box?.id)!).child(item.id!).child("name").setValue(name)
        let values: [String:Any] = ["name" : name, "isFragile": item.isFragile, "box" : (item.box?.id)!]
        ref.child("item_details").child(item.id!).updateChildValues(values)
    }
    
}

// MARK: - Place Data Processing

extension FirebaseDataManager {
    
    //Create new shared place
    static func processNewPlace(dict: [String:Any], sender: PlaceViewController) {
        var owner: String = ""
        var newPlaceDict: NSDictionary = [:]
        
        guard let placeID = dict["id"] as? String else {
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
            print("Place dictionary: \(dict)")
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
    
    
    
    // MARK: - Room Data Processing
    
    static func processNewRoom(dict: [String:Any], sender: RoomViewController) {
        var newRoomDict: NSDictionary = [:]
        
        print("new room dict: \(dict)")
        guard let roomID = dict["id"] as? String, let place = sender.place else {
            print("Error decoding room id")
            return
        }
        
        for room in sender.RoomsFetchedResultsController.fetchedObjects! {
            if room.id == roomID {
                print("room already exists, moving on")
                return
            }
        }
        
        newRoomDict = dict as NSDictionary
        PlaceController.createRoom(withDict: newRoomDict, inPlace: place)
        
    }
    
    // MARK: - Box Data Processing
    
    static func processNewBox(dict: [String:Any], sender: BoxViewController) {
        var newBoxDict: NSDictionary = [:]
        
        print("new box dict: \(dict)")
        guard let boxID = dict["id"] as? String, let room = sender.room else {
            print("Error decoding box id")
            return
        }
        
        for box in sender.BoxesFetchedResultsController.fetchedObjects! {
            if box.id == boxID {
                print("box already exists, moving on")
                return
            }
        }
        
        newBoxDict = dict as NSDictionary
        RoomController.createBox(withDictionary: newBoxDict, inRoom: room)
        
    }
    
    // MARK: - Item Data Processing
    
    static func processNewItem(dict: [String:Any], sender: ItemViewController) {
        var newItemDict: NSDictionary = [:]
        
        print("new box dict: \(dict)")
        guard let itemID = dict["id"] as? String, let box = sender.box else {
            print("Error decoding item id")
            return
        }
        
        for item in sender.ItemsFetchedResultsController.fetchedObjects! {
            if item.id == itemID {
                print("box already exists, moving on")
                return
            }
        }
        
        newItemDict = dict as NSDictionary
        BoxController.createItem(withDictionary: newItemDict, inBox: box)
        
    }
}