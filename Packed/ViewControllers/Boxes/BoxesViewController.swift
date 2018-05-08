//
//  BoxesViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class BoxViewController: MainViewController {
    
    var room: Room?
    
    var BoxesFetchedResultsController: NSFetchedResultsController<Box> = NSFetchedResultsController()
    
    // MARK: - LIfe Cylec
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let room = room else { return }
        
        self.title = room.name
        
        noDataLabel.text = "You don't have any Boxes yet."
        instructionLabel.text = "Tap '+' to add a new Box."
        
        setupFetchedResultsController()
        BoxesFetchedResultsController.delegate = self
        
        try? BoxesFetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if BoxesFetchedResultsController.fetchedObjects?.count != nil && (BoxesFetchedResultsController.fetchedObjects?.count)! > 0 {
            noDataLabel.isHidden = true
            noDataLabel.alpha = 0.0
            instructionLabel.isHidden = true
            instructionLabel.alpha = 0.0
        }
    }
    
    // MARK: - View Setup
    
    private func setupFetchedResultsController(){
        
        
        let request: NSFetchRequest<Box> = Box.fetchRequest()
        
        var predicate = NSPredicate()
        
        if let room = self.room {
            predicate = NSPredicate(format: "room == %@", room)
        }
        request.predicate = predicate
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        BoxesFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
        
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let room = room else {return}
        room.boxCount += 1
        
        UIView.animate(withDuration: 0.2, animations: {
            self.noDataLabel.alpha = 0.0
            self.instructionLabel.alpha = 0.0
        }) { (_) in
            self.noDataLabel.isHidden = true
            self.instructionLabel.isHidden = true
            RoomController.createBox(withName: "\(room.name!) Box \(room.boxCount)", inRoom: room)
        }
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let box = BoxesFetchedResultsController.object(at: indexPath!)
        print("options pressed for \(box.name!)")
        let actionSheet = UIAlertController(title: box.name, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "Rename this Box", style: .default) { (_) in
            let renameBoxViewController = RenameBoxViewController()
            renameBoxViewController.box = box

            self.navigationController?.pushViewController(renameBoxViewController, animated: true)
        }
        actionSheet.addAction(updateAction)
        let deleteAction = UIAlertAction(title: "Delete \(box.name!)", style: .destructive) { (_) in
            RoomController.delete(box: box)
            
            if (self.BoxesFetchedResultsController.fetchedObjects?.count)! <= 0 {
                self.noDataLabel.isHidden = false
                self.instructionLabel.isHidden = false
                self.room?.boxCount = 0
                
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
        return BoxesFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoxesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        let box = BoxesFetchedResultsController.object(at: indexPath)
        cell.setupCell(name: box.name!, image: #imageLiteral(resourceName: "BoxIcon"))
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let box = BoxesFetchedResultsController.object(at: indexPath)
        let itemsVC = ItemViewController()
        itemsVC.box = box
        navigationController?.pushViewController(itemsVC, animated: true)
        
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BoxViewController: NSFetchedResultsControllerDelegate{
    
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
