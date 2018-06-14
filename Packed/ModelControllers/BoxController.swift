//
//  BoxController.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class BoxController {
    
    //Edit Box
    static func update(box: Box, withName newName: String, isFragile newIsFragile: Bool){
        box.name = newName
        box.isFragile = newIsFragile
        if (box.room?.place?.isShared)! {
            FirebaseDataManager.update(box: box, withName: newName)
        }
    }
    
    //create Item
    static func createItem(withName name: String, inBox box: Box, isFragile: Bool){
        let newItem = Item(name: name, box: box, isFragile: isFragile)
        
        if (box.room?.place?.isShared)! {
            FirebaseDataManager.create(item: newItem)
        }
        saveData()
        
        checkFragileState(forBox: box)
    }
    
    static func createItem(withDictionary dict: NSDictionary, inBox box: Box){
        let _ = Item(withDict: dict, inBox: box)
        
        saveData()
        
        checkFragileState(forBox: box)
    }
    
    //Update Item
    static func update(item: Item, withName newName: String, isFragile newIsFragile: Bool){
        item.name = newName
        item.isFragile = newIsFragile
        
        if (item.box?.room?.place?.isShared)! {
            FirebaseDataManager.update(item: item, withName: newName)
        }
        
        checkFragileState(forBox: item.box!)
    }
    
    //delete Item
    static func delete(item: Item){
        guard let box = item.box else {return}
        
        if (box.room?.place?.isShared)! {
            FirebaseDataManager.delete(item: item)
        }
        
        item.managedObjectContext?.delete(item)
        
        saveData()
        
        checkFragileState(forBox: box)
    }
    
    private static func saveData(){
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    private static func checkFragileState(forBox box: Box){
        if (box.items?.count)! <= 0 {
            box.isFragile = false
            if (box.room?.place?.isShared)!{
                FirebaseDataManager.update(box: box, withName: box.name!)
            }
            return
        }
        let items = box.items!.compactMap({$0 as? Item})
        
        for item in items {
            if item.isFragile{
                box.isFragile = true
                if (box.room?.place?.isShared)!{
                    FirebaseDataManager.update(box: box, withName: box.name!)
                }
                return
            }
        }
        box.isFragile = false
        if (box.room?.place?.isShared)!{
            FirebaseDataManager.update(box: box, withName: box.name!)
        }
        return
    }
    
}
