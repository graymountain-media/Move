//
//  FirebaseDataController.swift
//  Packed
//
//  Created by Jake Gray on 6/4/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class FirebaseDataManager {
    
    // MARK: - Places
    
    static func share(place: Place) {
        let placesRef = ref.child("places").child((place.id?.uuidString)!)
        
        let values: [String:Any] = ["name" : place.name ?? "Default Name", "owner" : place.owner ?? "Default Owner", "isHome" : place.isHome]
        
        placesRef.updateChildValues(values)
        place.isShared = true
    }
    
    static func update(place: Place, withName name: String) {
        ref.child("places").child((place.id?.uuidString)!).child("name").setValue(name)
    }
    
    static func delete(place: Place) {
        for room in place.rooms! {
            delete(room: room as! Room)
        }
        ref.child("places").child((place.id?.uuidString)!).removeValue()
    }
    
    // MARK: - Rooms
    
    static func create(room: Room) {
        let roomsRef = ref.child("rooms").child((room.place?.id?.uuidString)!).child((room.id?.uuidString)!)
        
        let values: [String:Any] = ["name" : room.name ?? "Default Name"]
        
        roomsRef.updateChildValues(values)
    }
    
    static func update(room: Room, withName name: String) {
        ref.child("rooms").child((room.place?.id?.uuidString)!).child((room.id?.uuidString)!).child("name").setValue(name)
    }
    
    static func delete(room: Room) {
        for box in room.boxes!{
            delete(box: box as! Box)
        }
        ref.child("rooms").child((room.place?.id?.uuidString)!).child((room.id?.uuidString)!).removeValue()
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
    
}
