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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let room = fetchedResultsController.object(at: indexPath)
        cell.update(withTitle: room.name!)
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let spaceToDelete = fetchedResultsController.object(at: indexPath)
            SpaceController.delete(space: spaceToDelete)
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
        let space = fetchedResultsController.object(at: spaceIndex)
        SpaceController.delete(space: space)
        mainTableView.deleteRows(at: [spaceIndex], with: .automatic)
    }
    
    
    
}

