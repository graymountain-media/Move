//
//  FireBaseDataManagerDestroyer.swift
//  Packed
//
//  Created by Jake Gray on 6/5/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation
import FirebaseAuth

extension FirebaseDataManager {
    
    // MARK: - Place Deletion
    
    static func delete(place: Place) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        if place.owner! == userID {
            for room in place.rooms! {
                delete(room: room as! Room)
            }
            ref.child("places").child(place.id!).removeValue()
        } else {
            print("You are not the owner")
        }
    }
    
    // MARK: - Room Deletion
    
    static func delete(room: Room) {
        for box in room.boxes!{
            delete(box: box as! Box)
        }
        ref.child("rooms").child((room.place?.id)!).child(room.id!).removeValue()
    }
    
    // MARK: - Box Deletion
    
    static func delete(box: Box) {
        for item in box.items! {
            delete(item: item as! Item)
        }
        ref.child("boxes").child((box.room?.id)!).child(box.id!).removeValue()
    }
    
    // MARK: - Item Deletion
    
    static func delete(item: Item) {
        ref.child("items").child((item.box?.id)!).child(item.id!).removeValue()
        ref.child("item_details").child(item.id!).removeValue()
    }
    
}
