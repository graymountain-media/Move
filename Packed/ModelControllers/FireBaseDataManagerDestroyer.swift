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
        guard let userID = Auth.auth().currentUser?.uid else {return}
        for room in place.rooms! {
            delete(room: room as! Room)
        }
        ref.child("places").child(place.id!).removeValue()
        ref.child("shared").child(userID).child(place.id!).removeValue()
        ref.child("owned").child(userID).child(place.id!).removeValue()
    }
    
    static func processPlaceRemoval(dict: [String : AnyObject], sender: PlaceViewController){
        print("Place removed: \(dict)")
        
        let tempPlace = Place(dict: dict as NSDictionary)

        PlaceController.delete(place: tempPlace)
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
