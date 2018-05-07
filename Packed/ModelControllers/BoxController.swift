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
    static func update(box: Box, withName newName: String){
        box.name = newName
    }
    
    //create Item
    static func createItem(withName name: String, inBox box: Box ){
        let _ = Item(name: name, box: box)
        saveData()
    }
    //Update Item
    static func update(item: Item, withName newName: String){
        item.name = newName
    }
    
    //delete Item
    static func delete(item: Item){
        item.managedObjectContext?.delete(item)
        
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
