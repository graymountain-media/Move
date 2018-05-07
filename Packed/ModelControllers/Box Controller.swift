//
//  Box Controller.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import Foundation

class BoxContoller {
    
    //Edit Box
    static func update(box: Box, withName newName: String){
        box.name = newName
    }
    
    //create Box
    static func createItem(withName name: String, inBox box: Box ){
        let _ = Item(name: name, box: box)
        saveData()
    }
    
    //delete Box
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
