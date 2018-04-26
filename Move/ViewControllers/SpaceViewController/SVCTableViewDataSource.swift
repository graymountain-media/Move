//
//  SVCTableViewDataSource.swift
//  Move
//
//  Created by Jake Gray on 4/24/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension SpacesViewController: UITableViewDelegate, UITableViewDataSource, TitleTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SpacesFetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpacesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let room = SpacesFetchedResultsController.object(at: indexPath)
        cell.update(withTitle: room.name, image: #imageLiteral(resourceName: "HomeIcon"))
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        self.mainTableView.setEditing(editing, animated: true)
        
    }
    
    func deleteButtonPressed(_ sender: TitleTableViewCell) {
        guard let indexPath = mainTableView.indexPath(for: sender) else {return}
        let space = SpacesFetchedResultsController.object(at: indexPath)
        SpaceController.delete(space: space)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = RoomViewController()
        destinationVC.space = SpacesFetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(destinationVC, animated: true)
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

