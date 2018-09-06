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
        saveData()
    }
    
    //create Item
    static func createItem(withName name: String, inBox box: Box, isFragile: Bool){
        let _ = Item(name: name, box: box, isFragile: isFragile)
        saveData()
        
        checkFragileState(forBox: box)
    }
    //Update Item
    static func update(item: Item, withName newName: String, isFragile newIsFragile: Bool){
        item.name = newName
        item.isFragile = newIsFragile
        
        
        checkFragileState(forBox: item.box!)
        saveData()
    }
    
    //delete Item
    static func delete(item: Item){
        guard let box = item.box else {return}
        
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
            return
        }
        let items = box.items!.compactMap({$0 as? Item})
        
        for item in items {
            if item.isFragile{
                box.isFragile = true
                return
            }
        }
        box.isFragile = false
        return
    }
    
}
