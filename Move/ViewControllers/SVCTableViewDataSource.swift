//
//  SVCTableViewDataSource.swift
//  Move
//
//  Created by Jake Gray on 4/24/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit


// MARK: - TableView Data Source

extension SpacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpaceController.shared.spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let room = SpaceController.shared.spaces[indexPath.row]
        cell.update(withTitle: room.name)
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let space = SpaceController.shared.spaces[indexPath.row]
            SpaceController.shared.delete(space: space)
            
            mainTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        self.mainTableView.setEditing(editing, animated: true)
        
    }
    
    func deleteButtonPressed() {
        print("Delete processing")
        guard let spaceIndex = mainTableView.indexPathForSelectedRow else {return}
        let space = SpaceController.shared.spaces[spaceIndex.row]
        SpaceController.shared.delete(space: space)
        mainTableView.deleteRows(at: [spaceIndex], with: .automatic)
    }
    
    
    
}

