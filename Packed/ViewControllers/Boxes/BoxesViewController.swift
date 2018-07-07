//
//  BoxesViewController.swift
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

class BoxViewController: MainViewController {
    
    var room: Room?
    
    var boxesAddedHandle = UInt()
    var boxesReference = DatabaseReference()
    var boxes: [Box] = [] {
        didSet {
            print(boxes.compactMap({$0.name!}))
            print("Sorted: \(boxes.compactMap({$0.name!}))")
            
        }
    }
    
    var BoxesFetchedResultsController: NSFetchedResultsController<Box> = NSFetchedResultsController()
    
    // MARK: - LIfe Cylec
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let room = room else { return }
        print(room)
        
        viewTitle = room.name!
        
        noDataLabel.text = "You don't have any Boxes yet."
        instructionLabel.text = "Tap '+' to add a new Box."
        
        setupFetchedResultsController()
        BoxesFetchedResultsController.delegate = self
        
        try? BoxesFetchedResultsController.performFetch()
        boxes = BoxesFetchedResultsController.fetchedObjects ?? []
        sortBoxes()
        
        setupHandle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
        mainTableView.reloadData()
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle!)
        boxesReference.removeAllObservers()
    }
    
    private func setupHandle() {
        guard let room = room else {return}
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                self.boxesReference = ref.child("boxes").child(room.id!)
                self.setupObservers()
            }
        }
    }
    
    private func setupObservers() {
        boxesReference.observe(DataEventType.childAdded, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            FirebaseDataManager.processNewBox(dict: dict, sender: self)
            DispatchQueue.main.async {
                self.noDataLabel.isHidden = true
                self.noDataLabel.alpha = 0.0
                self.instructionLabel.isHidden = true
                self.instructionLabel.alpha = 0.0
            }
        })
        
        boxesReference.observe(DataEventType.childRemoved, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            guard let boxID = dict["id"] as? String else {return}
            for box in self.BoxesFetchedResultsController.fetchedObjects! {
                if box.id == boxID {
                    RoomController.delete(box: box)
                }
            }
            if self.BoxesFetchedResultsController.fetchedObjects?.count == 0 {
                self.room?.boxCount = 1
            }
            DispatchQueue.main.async {
                self.updateView()
            }
        })
        
        boxesReference.observe(DataEventType.childChanged, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            guard let boxID = dict["id"] as? String, let newName = dict["name"] as? String, let newIsFragile = dict["isFragile"] as? Bool else {return}
            for box in self.BoxesFetchedResultsController.fetchedObjects! {
                if box.id == boxID {
                    BoxController.update(box: box, withName: newName, isFragile: newIsFragile)
                }
            }
            DispatchQueue.main.async {
                self.updateView()
            }
        })
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
        
        BoxesFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }
   
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        guard let room = room else {return}
//        room.boxCount += 1
        
        UIView.animate(withDuration: 0.2, animations: {
            self.noDataLabel.alpha = 0.0
            self.instructionLabel.alpha = 0.0
        }) { (_) in
            self.noDataLabel.isHidden = true
            self.instructionLabel.isHidden = true
            if room.boxCount < 10 {
                RoomController.createBox(withName: "\(room.name!) Box 0\(room.boxCount)", inRoom: room)
            } else {
                RoomController.createBox(withName: "\(room.name!) Box \(room.boxCount)", inRoom: room)
            }
            
        }
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let box = BoxesFetchedResultsController.object(at: indexPath!)
        
        let actionSheet = UIAlertController(title: box.name, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete \(box.name!)", style: .destructive) { (_) in
            RoomController.delete(box: box)
            self.mainTableView.deleteRows(at: [indexPath!], with: .automatic)
    
            self.updateView()
            if self.BoxesFetchedResultsController.fetchedObjects?.count == 0 {
                self.room?.boxCount = 1
            }
        }
        actionSheet.addAction(deleteAction)
        
        let updateAction = UIAlertAction(title: "Rename this Box", style: .default) { (_) in
            let renameBoxViewController = RenameBoxViewController()
            renameBoxViewController.box = box
            
            let navController = UINavigationController(rootViewController: renameBoxViewController)
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
    
    private func sortBoxes() {
        boxes = boxes.sorted { (leftBox, rightBox) -> Bool in
            let leftComponents = leftBox.name!.lowercased().split(separator: " ")
            let rightComponents = rightBox.name!.lowercased().split(separator: " ")
            
            var limit = leftComponents.count < rightComponents.count ? leftComponents.count : rightComponents.count
            
            for i in 0...limit - 1 {
                let leftString = String(leftComponents[i])
                let rightString = String(rightComponents[i])

                if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: leftString)) || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: rightString)) {
                    if leftComponents[i] != rightComponents[i] {
                        return leftComponents[i] < rightComponents[i]
                    }
                } else if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: leftString)) && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: rightString)) {
                    
                    return Int(leftString)! < Int(rightString)!
                }
            }
            
            return !(leftBox.name!.lowercased() > rightBox.name!.lowercased())
        }
    }
    
    override func updateView(){
        
        if BoxesFetchedResultsController.fetchedObjects?.count != nil && (BoxesFetchedResultsController.fetchedObjects?.count)! > 0 {
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
        return BoxesFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoxesFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        print(indexPath)
        let box = BoxesFetchedResultsController.object(at: indexPath)
        cell.updateCellWith(name: box.name!, image: #imageLiteral(resourceName: "BoxIcon"), isFragile: box.isFragile)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let box = BoxesFetchedResultsController.object(at: indexPath)
            RoomController.delete(box: box)
            updateView()
            if BoxesFetchedResultsController.fetchedObjects?.count == 0 {
                room?.boxCount = 1
            }
        }
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
            print("delete")
            mainTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            mainTableView.insertRows(at: [newIndexPath!], with: .automatic)
            print("insert")
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
            print("insert")
        default:
            fatalError("Can't edit sections like that")
        }
    }
}
