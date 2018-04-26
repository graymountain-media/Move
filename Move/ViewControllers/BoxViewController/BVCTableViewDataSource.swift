//
//  BVCTableViewDataSource.swift
//  Move
//
//  Created by Jake Gray on 4/26/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension BoxViewController: UITableViewDelegate, UITableViewDataSource, TitleTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BoxesFetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoxesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let box = BoxesFetchedResultsController.object(at: indexPath)
        cell.update(withTitle: box.name!, image: #imageLiteral(resourceName: "BoxIcon"))
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func deleteButtonPressed(_ sender: TitleTableViewCell) {
        guard let indexPath = mainTableView.indexPath(for: sender) else {return}
        let box = BoxesFetchedResultsController.object(at: indexPath)
        RoomController.delete(box: box)
        mainTableView.deselectRow(at: indexPath, animated: true)
        
        if BoxesFetchedResultsController.sections!.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.noEntitiesLabel.isHidden = false
                self.noEntitiesLabel.alpha = 1.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ItemViewController()
        destinationVC.box = BoxesFetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(destinationVC, animated: true)
        mainTableView.deselectRow(at: indexPath, animated: true)
        nameTextField.resignFirstResponder()
    }
    
    
}

