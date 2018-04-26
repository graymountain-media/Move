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
        cell.update(withTitle: room.name!, image: #imageLiteral(resourceName: "RoomIcon"))
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
        
        if RoomsFetchedResultsController.sections!.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.noEntitiesLabel.isHidden = false
                self.noEntitiesLabel.alpha = 1.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = BoxViewController()
        destinationVC.room = RoomsFetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(destinationVC, animated: true)
        mainTableView.deselectRow(at: indexPath, animated: true)
        nameTextField.resignFirstResponder()
    }
    
   
    
}
