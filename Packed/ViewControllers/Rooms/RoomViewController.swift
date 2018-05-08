//
//  RoomViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class RoomViewController: MainViewController {
    
    var place: Place?
    
    var RoomsFetchedResultsController: NSFetchedResultsController<Room> = NSFetchedResultsController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Rooms"
        noDataLabel.text = "You don't have any Rooms yet."
        instructionLabel.text = "Tap '+' to add a new Room."
        
        setupFetchedResultsController()
        RoomsFetchedResultsController.delegate = self
        
        try? RoomsFetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if RoomsFetchedResultsController.fetchedObjects?.count != nil && (RoomsFetchedResultsController.fetchedObjects?.count)! > 0 {
            noDataLabel.isHidden = true
            noDataLabel.alpha = 0.0
            instructionLabel.isHidden = true
            instructionLabel.alpha = 0.0
            
        }
    }
    
    // MARK: - View Setup
    
    private func setupFetchedResultsController(){
        
        
        let request: NSFetchRequest<Room> = Room.fetchRequest()
        
        var predicate = NSPredicate()
        
        if let place = self.place {
            predicate = NSPredicate(format: "place == %@", place)
        }
        request.predicate = predicate
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        RoomsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
        
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let place = place else {return}
        
        let roomDetailViewController = RoomDetailViewController()
        roomDetailViewController.place = place
        
        navigationController?.pushViewController(roomDetailViewController, animated: true)
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let room = RoomsFetchedResultsController.object(at: indexPath!)
        print("options pressed for \(room.name!)")
        let actionSheet = UIAlertController(title: room.name, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete \(room.name!)", style: .destructive) { (_) in
            PlaceController.delete(room: room)
            
            if (self.RoomsFetchedResultsController.fetchedObjects?.count)! <= 0 {
                self.noDataLabel.isHidden = false
                self.instructionLabel.isHidden = false
                
                UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                    self.noDataLabel.alpha = 1
                    self.instructionLabel.alpha = 1
                }, completion: nil)
            }
        }
        actionSheet.addAction(deleteAction)
        
        let updateAction = UIAlertAction(title: "Rename this Room", style: .default) { (_) in
            let roomDetailViewController = RoomDetailViewController()
            roomDetailViewController.room = room
            
            self.navigationController?.pushViewController(roomDetailViewController, animated: true)
        }
        actionSheet.addAction(updateAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RoomsFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomsFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        let room = RoomsFetchedResultsController.object(at: indexPath)
        cell.setupCell(name: room.name!, image: #imageLiteral(resourceName: "RoomIcon"))
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = RoomsFetchedResultsController.object(at: indexPath)
        let boxesVC = BoxViewController()
        boxesVC.room = room
        navigationController?.pushViewController(boxesVC, animated: true)
        
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RoomViewController: NSFetchedResultsControllerDelegate{
    
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
