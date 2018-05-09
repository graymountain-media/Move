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
        viewTitle = box.name!
        
        noDataLabel.text = "You don't have any Items yet."
        instructionLabel.text = "Tap '+' to add a new Item."
        
        setupFetchedResultsController()
        ItemsFetchedResultsController.delegate = self
        
        try? ItemsFetchedResultsController.performFetch()
        
        mainTableView.register(PackedItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        
        ItemsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let box = box else {return}
        
        let itemDetailViewController = ItemDetailViewController()
        itemDetailViewController.box = box
        
        let navController = UINavigationController(rootViewController: itemDetailViewController)
        navController.setupBar()
        navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    override func updateView(){
        
        if ItemsFetchedResultsController.fetchedObjects?.count != nil && (ItemsFetchedResultsController.fetchedObjects?.count)! > 0 {
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
        return ItemsFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedItemTableViewCell else {return PackedItemTableViewCell()}
        
        let item = ItemsFetchedResultsController.object(at: indexPath)
        cell.setupCell(name: item.name!, image: #imageLiteral(resourceName: "ItemIcon"), isFragile: item.isFragile)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let box = self.box else {return}
        let item = ItemsFetchedResultsController.object(at: indexPath)
        let itemDetailVC = ItemDetailViewController()
        itemDetailVC.item = item
        itemDetailVC.box = box
        navigationController?.pushViewController(itemDetailVC, animated: true)
        
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemsFetchedResultsController.object(at: indexPath)
            BoxController.delete(item: item)
            updateView()
        }
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
            fatalError("Can't edit sections like that")
        }
    }
}

