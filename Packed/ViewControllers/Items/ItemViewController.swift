//
//  ItemViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: MainViewController {
    
    var box: Box?
    
    var ItemsFetchedResultsController: NSFetchedResultsController<Item> = NSFetchedResultsController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let box = self.box else {return}
        self.title = box.name
        
        noDataLabel.text = "You don't have any Items yet."
        instructionLabel.text = "Tap '+' to add a new Item."
        mainTableView.allowsSelection = false
        
        setupFetchedResultsController()
        ItemsFetchedResultsController.delegate = self
        
        try? ItemsFetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ItemsFetchedResultsController.fetchedObjects?.count != nil && (ItemsFetchedResultsController.fetchedObjects?.count)! > 0 {
            noDataLabel.isHidden = true
            noDataLabel.alpha = 0.0
            instructionLabel.isHidden = true
            instructionLabel.alpha = 0.0
            searchController.searchBar.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - View Setup
    
    private func setupFetchedResultsController(){
        
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        var predicate = NSPredicate()
        
        if let box = self.box {
            predicate = NSPredicate(format: "box == %@", box)
        }
        request.predicate = predicate
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        ItemsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
        
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let box = box else {return}
        
        let itemDetailViewController = ItemDetailViewController()
        itemDetailViewController.box = box
        
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let item = ItemsFetchedResultsController.object(at: indexPath!)
        print("options pressed for \(item.name!)")
        let actionSheet = UIAlertController(title: item.name, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "Rename this Item", style: .default) { (_) in
            let itemDetailViewController = ItemDetailViewController()
            itemDetailViewController.item = item
            
            self.navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
        actionSheet.addAction(updateAction)
        let deleteAction = UIAlertAction(title: "Delete \(item.name!)", style: .destructive) { (_) in
            BoxController.delete(item: item)
            if (self.ItemsFetchedResultsController.fetchedObjects?.count)! <= 0 {
                self.noDataLabel.isHidden = false
                self.instructionLabel.isHidden = false
                self.searchController.searchBar.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                    self.noDataLabel.alpha = 1
                    self.instructionLabel.alpha = 1
                }, completion: nil)
            }
        }
        actionSheet.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemsFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        let item = ItemsFetchedResultsController.object(at: indexPath)
        cell.setupCell(name: item.name!, image: #imageLiteral(resourceName: "ItemIcon"))
        cell.delegate = self
        
        return cell
    }
}

extension ItemViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        mainTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        mainTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            mainTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            mainTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            mainTableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            mainTableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet.init(integer: sectionIndex)
        switch type {
        case .delete:
            mainTableView.deleteSections(indexSet, with: .automatic)
        case .insert:
            mainTableView.insertSections(indexSet, with: .automatic)
        default:
            print("Can't edit sections like that")
        }
    }
}

