//
//  RoomViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RoomViewController: MainViewController {
    
    var place: Place?
    
    var roomsAddedReference = UInt()
    
    var RoomsFetchedResultsController: NSFetchedResultsController<Room> = NSFetchedResultsController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let place = place else {return}
        viewTitle = place.name!
        
        noDataLabel.text = "You don't have any Rooms yet."
        instructionLabel.text = "Tap '+' to add a new Room."
        
        setupFetchedResultsController()
        RoomsFetchedResultsController.delegate = self
        
        try? RoomsFetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
        guard let place = place else {return}
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                
                self.roomsAddedReference = ref.child("rooms").child(place.id!).observe(DataEventType.childAdded, with: { (snapshot) in
                    let dict = snapshot.value as? [String : AnyObject] ?? [:]
                    FirebaseDataManager.processNewRoom(dict: dict, sender: self)
                })
            }
            print("*************AUTH in Rooms: \(auth.currentUser?.email)")
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
        
        RoomsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let place = place else {return}
        
        let roomDetailViewController = RoomDetailViewController()
        roomDetailViewController.place = place
        let navController = UINavigationController(rootViewController: roomDetailViewController)
        navController.setupBar()
        navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let room = RoomsFetchedResultsController.object(at: indexPath!)
        
        let actionSheet = UIAlertController(title: room.name, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete \(room.name!)", style: .destructive) { (_) in
            PlaceController.delete(room: room)
            
            self.updateView()
        }
        actionSheet.addAction(deleteAction)
        
        let updateAction = UIAlertAction(title: "Rename this Room", style: .default) { (_) in
            let roomDetailViewController = RoomDetailViewController()
            roomDetailViewController.room = room
            
            let navController = UINavigationController(rootViewController: roomDetailViewController)
            navController.setupBar()
            navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        actionSheet.addAction(updateAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    override func updateView(){
        
        if RoomsFetchedResultsController.fetchedObjects?.count != nil && (RoomsFetchedResultsController.fetchedObjects?.count)! > 0 {
            noDataLabel.isHidden = true
            noDataLabel.alpha = 0.0
            instructionLabel.isHidden = true
            instructionLabel.alpha = 0.0
            
        } else {
            self.noDataLabel.isHidden = false
            self.instructionLabel.isHidden = false
            
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.noDataLabel.alpha = 1
                self.instructionLabel.alpha = 1
            }, completion: nil)
        }
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
        cell.updateCellWith(name: room.name!, image: #imageLiteral(resourceName: "RoomIcon"), isFragile: false)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = RoomsFetchedResultsController.object(at: indexPath)
            PlaceController.delete(room: room)
            updateView()
        }
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
            fatalError("Can't edit sections like that")
        }
    }
}
