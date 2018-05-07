//
//  PlaceViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class PlaceViewController: MainViewController {

    var data: [Place] = []
    
    let PlacesFetchedResultsController: NSFetchedResultsController<Place> = {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataLabel.text = "You don't have any Places yet."
        instructionLabel.text = "Tap '+' to add a new Place."
        
        self.title = "Places"
        PlacesFetchedResultsController.delegate = self

        try? PlacesFetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        try? PlacesFetchedResultsController.performFetch()
        
        if PlacesFetchedResultsController.fetchedObjects?.count != nil && (PlacesFetchedResultsController.fetchedObjects?.count)! > 0 {
            noDataLabel.isHidden = true
            instructionLabel.isHidden = true
        }
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        
        print("Add button pressed")
        let newPlaceViewController = NewPlaceViewController()
        navigationController?.pushViewController(newPlaceViewController, animated: true)
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let place = PlacesFetchedResultsController.object(at: indexPath!)
        print("options pressed for \(place.name!)")
        let actionSheet = UIAlertController(title: place.name, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "Rename this Place", style: .default) { (_) in
            let renamePlaceViewController = RenamePlaceViewController()
            renamePlaceViewController.place = place
            self.navigationController?.pushViewController(renamePlaceViewController, animated: true)
        }
        actionSheet.addAction(updateAction)
        let deleteAction = UIAlertAction(title: "Delete \(place.name!)", style: .destructive) { (_) in
            PlaceController.delete(place: place)
        }
        actionSheet.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlacesFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlacesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        let item = PlacesFetchedResultsController.object(at: indexPath)
        let image = item.isHome ? #imageLiteral(resourceName: "HomeIcon") : #imageLiteral(resourceName: "StorageIcon")
        cell.setupCell(name: item.name!, image: image)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = PlacesFetchedResultsController.object(at: indexPath)
        if place.isHome{
            let roomVC = RoomViewController()
            roomVC.place = place
            navigationController?.pushViewController(roomVC, animated: true)
        } else {
            let boxesVC = BoxViewController()
            let rooms = place.rooms?.compactMap({$0 as? Room})
            boxesVC.room = rooms?.first
            navigationController?.pushViewController(boxesVC, animated: true)
        }
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PlaceViewController: NSFetchedResultsControllerDelegate{
    
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

