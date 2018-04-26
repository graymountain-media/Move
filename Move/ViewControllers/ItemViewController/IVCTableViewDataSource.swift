//
//  IVCTableViewDataSource.swift
//  Move
//
//  Created by Jake Gray on 4/26/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension ItemViewController: UITableViewDelegate, UITableViewDataSource, TitleTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemsFetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let item = ItemsFetchedResultsController.object(at: indexPath)
        cell.update(withTitle: item.name!, image: #imageLiteral(resourceName: "ItemIcon"))
        cell.delegate = self
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func deleteButtonPressed(_ sender: TitleTableViewCell) {
        guard let indexPath = mainTableView.indexPath(for: sender) else {return}
        let item = ItemsFetchedResultsController.object(at: indexPath)
        BoxContoller.delete(item: item)
        mainTableView.deselectRow(at: indexPath, animated: true)
        
        if ItemsFetchedResultsController.sections!.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.noEntitiesLabel.isHidden = false
                self.noEntitiesLabel.alpha = 1.0
            }
        }
    }
    
    
}
