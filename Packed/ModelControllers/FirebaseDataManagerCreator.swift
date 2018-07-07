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
import FirebaseAuth

class FirebaseDataManager {
    
    // MARK: - Place Creation
    
    static func share(place: Place, toUser user: String) {
        let placesRef = ref.child("places").child(place.id!)
        
        let values: [String:Any] = ["name" : place.name ?? "Default Name", "owner" : place.owner ?? "Default Owner", "isHome" : place.isHome, "id" : place.id!]
        
        placesRef.updateChildValues(values)
        place.isShared = true
        
        if place.id == nil {
            place.id = UUID().uuidString
        }
        
        ref.child("shared").child(user).child(place.id!).updateChildValues(["name" : place.name!, "id" : place.id!])
        ref.child("owned").child(Auth.auth().currentUser!.uid).child(place.id!).updateChildValues(["name" : place.name!, "id" : place.id!])
        
        guard let rooms = place.rooms else {return}
        
        for object in rooms {
            guard let room = object as? Room else {print("Cannot convert to room"); return}
            if room.id == nil {
                room.id = UUID().uuidString
            }
            create(room: room)
//            ref.child("rooms").child(place.id!).updateChildValues(["name": room.name!, "id": room.id!])
            
            guard let boxes = room.boxes else {return}
            for object in boxes {
                guard let box = object as? Box else {print("Cannot convert to box"); return}
                if box.id == nil {
                    box.id = UUID().uuidString
                }
                create(box: box)
//                ref.child("boxes").child(room.id!).child(box.id!).updateChildValues(["name": box.name!, "idFragile": box.isFragile])
                
                guard let items = box.items else {return}
                for object in items {
                    guard let item = object as? Item else {print("Cannot convert to item"); return}
                    if item.id == nil {
                        item.id = UUID().uuidString
                    }
                    create(item: item)
//                    ref.child("items").child(box.id!).child(item.id!).updateChildValues("name": item.name!, "idFragile": item.isFragile, "box": box.id,"id", item.isFragile])
                }
            }
        }
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
        
        let values: [String:Any] = ["name" : item.name ?? "Default Name", "id" : item.id!, "isFragile" : item.isFragile, "box" : (item.box?.id)!]
        
        itemsRef.updateChildValues(values)
        
//        let detailValues: [String:Any] = ["name" : item.name!, "isFragile": item.isFragile, "box" : (item.box?.id)!]
//        ref.child("items").child(item.id!).updateChildValues(detailValues)
    }
    
    static func update(item: Item, withName name: String) {
        let itemRef = ref.child("items").child((item.box?.id)!).child(item.id!)
        let values: [String:Any] = ["name" : name, "isFragile": item.isFragile, "box" : (item.box?.id)!]
        itemRef.updateChildValues(values)
//        ref.child("items").child(item.id!).updateChildValues(values)
    }
    
}

// MARK: - Data Processing

extension FirebaseDataManager {
    
    static func fetchOwnedPlaces(existingIds ids: [String], completion: @escaping (Bool) -> Void ) {
        ref.child("owned").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let dict = snapshot.value as? [String:Any] ?? [:]
            
            PlaceController.recreatePlaces(fromDict: dict, withIds: ids)
        }
        completion(true)
    }
    
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
            
            if dict == [:] {
                print("No shared Place Found")
                removeShared(id: placeID)
                return
            }
            print("Place dictionary: \(dict)")
            let ownerID = dict["owner"] as! String
            newPlaceDict = dict
            
            ref.child("users").child(ownerID).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                let dict = snapshot.value as? NSDictionary ?? [:]
                owner = dict["name"] as? String ?? "User"
                print("user dict: \(dict)")
                newPlaceDict.setValue(owner, forKey: "ownerName")
                newPlaceDict.setValue(placeID, forKey: "id")
                
                let newPlace = PlaceController.createPlace(withDict: newPlaceDict)
                
                ref.child("rooms").child(placeID).observe(DataEventType.childAdded, with: { (snapshot) in
                    let dict = snapshot.value as? [String : AnyObject] ?? [:]
                    FirebaseDataManager.processStorageRoom(dict: dict, place: newPlace)
                    
                })
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
    
    static func processStorageRoom(dict: [String:Any], place: Place) {
        var newRoomDict: NSDictionary = [:]
        
        print("new room dict: \(dict)")
        guard let roomID = dict["id"] as? String else {
            print("Error decoding room id")
            return
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
