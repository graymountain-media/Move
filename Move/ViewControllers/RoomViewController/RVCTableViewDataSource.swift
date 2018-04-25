//
//  RVCTableViewDataSource.swift
//  Move
//
//  Created by Jake Gray on 4/25/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension RoomViewController: UITableViewDelegate, UITableViewDataSource, TitleTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RoomsFetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomsFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let room = RoomsFetchedResultsController.object(at: indexPath)
        cell.update(withTitle: room.name!)
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func deleteButtonPressed(_ sender: TitleTableViewCell) {
        guard let indexPath = mainTableView.indexPath(for: sender) else {return}
        let room = RoomsFetchedResultsController.object(at: indexPath)
        SpaceController.delete(room: room)
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
