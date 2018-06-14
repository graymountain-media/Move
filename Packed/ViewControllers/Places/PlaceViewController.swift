//
//  PlaceViewController.swift
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

class PlaceViewController: MainViewController {
    
    var sharedReference = DatabaseReference()
    var placeReference = DatabaseReference()
    var references: [DatabaseReference] = []

    var data: [Place] = []
    var loginButton = UIBarButtonItem()
    var userId: String = ""
    var isLoggedIn: Bool = false
    
    let blurredBackgroundView = UIVisualEffectView()
    
    //Menu Items
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = offWhite
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Place View Items
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        button.setImage(UIImage(named: "gear"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let PlacesFetchedResultsController: NSFetchedResultsController<Place> = {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        
        let sharedSort = NSSortDescriptor(key: "isShared", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sharedSort, nameSort]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isShared", cacheName: nil)
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupLoginButton()
        
        
        noDataLabel.text = "You don't have any Places yet."
        instructionLabel.text = "Tap '+' to add a new Place."
        
        viewTitle = "Places"
        PlacesFetchedResultsController.delegate = self

        try? PlacesFetchedResultsController.performFetch()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        setupHandle()
        setupBlur()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    deinit {
        sharedReference.removeAllObservers()
        Auth.auth().removeStateDidChangeListener(handle!)
        for ref in references {
            ref.removeAllObservers()
        }
    }
    
    private func setupHandle() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
//                self.isLoggedIn = true
//                self.loginButton.title = "Sign Out"
//                self.userId = (auth.currentUser?.uid)!
                
                self.sharedReference = ref.child("shared").child((Auth.auth().currentUser?.uid)!)
                self.placeReference = ref.child("places")
                self.setupSharedObserver()
                self.resetObservers()
            }
            print("*************AUTH In Places: \(auth.currentUser?.email)")
        }
    }
    
    private func resetObservers() {
        for place in PlacesFetchedResultsController.fetchedObjects! {
            if place.isShared {
                addObservers(toReference: placeReference.child(place.id!))
            }
        }
    }
    
    private func setupSharedObserver(){
        self.sharedReference.observe(DataEventType.childAdded, with: { (snapshot) in
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            let newPlaceReference = self.placeReference.child(dict["id"] as? String ?? "")
            
            self.addObservers(toReference: newPlaceReference)
            
            if !dict.isEmpty {
                FirebaseDataManager.processNewPlace(dict: dict, sender: self)
            }
            
            DispatchQueue.main.async {
                self.noDataLabel.isHidden = true
                self.noDataLabel.alpha = 0.0
                self.instructionLabel.isHidden = true
                self.instructionLabel.alpha = 0.0
            }
        })
    }
    
    private func addObservers(toReference ref: DatabaseReference) {
//        ref.observe(DataEventType.childAdded, with: { (snapshot) in
//            print("place child added")
//            let dict = snapshot.value as? [String : AnyObject] ?? [:]
//            print(dict)
//        })
        print("Observers Added")
        self.references.append(ref)
        
        ref.observe(DataEventType.childRemoved, with: { (_) in
            print("place child removed")
            let placeID = ref.key
            for place in self.PlacesFetchedResultsController.fetchedObjects! {
                if place.id == placeID {
                    PlaceController.delete(place: place)
                }
            }
            self.updateView()
        })
        ref.observe(DataEventType.childChanged, with: { (snapshot) in
            print("place child changed")
            ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                let dict = snapshot.value as? [String : AnyObject] ?? [:]
                guard let newName = dict["name"] as? String, let placeID = dict["id"] as? String, let newIsHome = dict["isHome"] as? Bool else {return}
                for place in self.PlacesFetchedResultsController.fetchedObjects! {
                    if place.id == placeID {
                        PlaceController.update(place: place, withName: newName, isHome: newIsHome)
                    }
                }
                
                DispatchQueue.main.async {
                    self.updateView()
                }
            })
        })
    }
    
    // MARK: - View Setup
    
    private func setupBlur(){
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        blurredBackgroundView.alpha = 0
        
        view.addSubview(blurredBackgroundView)
    }
    
    private func setupLoginButton() {

        loginButton = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(loginButtonPressed))
        navigationItem.leftBarButtonItem = loginButton
    }
    
    @objc private func settingsButtonPressed() {
        print("SETTINGS PRESSED")
        UIView.animate(withDuration: 0.3) {
            self.menuView.frame.origin.x = 0
        }
    }
    
    @objc private func loginButtonPressed(){
        if isLoggedIn {
            
            let alert = UIAlertController(title: "Are you sure you want to sign out?", message: "You will not be able to edit any shared Places while signed out", preferredStyle: .alert)
            
            let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
                try? Auth.auth().signOut()
                self.isLoggedIn = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.loginButton.title = "Login"
                    
                })
            }
            alert.addAction(signOutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            let loginController = LoginViewController()
            present(loginController, animated: true, completion: nil)
        }
    }
    
    @objc override func addButtonPressed() {
        super.addButtonPressed()
        
        let newPlaceViewController = NewPlaceViewController()
        let navController = UINavigationController(rootViewController: newPlaceViewController)
        navController.setupBar()
        navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Cell Delegate
    
    override func cellOptionsButtonPressed(sender: UITableViewCell) {
        let indexPath = mainTableView.indexPath(for: sender)
        let place = PlacesFetchedResultsController.object(at: indexPath!)
        
        let actionSheet = UIAlertController(title: place.name, message: nil, preferredStyle: .actionSheet)
       
        let deleteAction = UIAlertAction(title: "Delete \(place.name!)", style: .destructive) { (_) in
            
            PlaceController.delete(place: place)
            self.updateView()
        }
        
        actionSheet.addAction(deleteAction)
        
        let updateAction = UIAlertAction(title: "Rename this Place", style: .default) { (_) in
            let renamePlaceViewController = RenamePlaceViewController()
            renamePlaceViewController.place = place
            let navController = UINavigationController(rootViewController: renamePlaceViewController)
            navController.setupBar()
            navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        actionSheet.addAction(updateAction)
        
        let shareAction = UIAlertAction(title: "Share This Place", style: .default) { (_) in
//            let myDynamicLink = "WOOOOOW"
//            let msg = "Hey, check this out: " + myDynamicLink
//            let shareSheet = UIActivityViewController(activityItems: [ msg ], applicationActivities: nil)
//            shareSheet.popoverPresentationController?.sourceView = self.view
//            self.present(shareSheet, animated: true, completion: nil)
            place.owner = self.userId
            let shareView = ShareViewController()
            shareView.delegate = self
            shareView.place = place
            shareView.modalPresentationStyle = .overFullScreen
            self.addObservers(toReference: self.placeReference.child(place.id!))
            self.present(shareView, animated: true, completion: nil)
            UIView.animate(withDuration: 0.2, animations: {
                self.blurredBackgroundView.alpha = 1
            })
        }
        
        actionSheet.addAction(shareAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    override func updateView(){
        
        if PlacesFetchedResultsController.fetchedObjects?.count != nil && (PlacesFetchedResultsController.fetchedObjects?.count)! > 0 {
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
        mainTableView.reloadData()
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
        cell.updateCellWith(name: item.name!, image: image, isFragile: false)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = PlacesFetchedResultsController.object(at: indexPath)
            PlaceController.delete(place: place)
            updateView()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if PlacesFetchedResultsController.object(at: IndexPath(row: 0, section: section)).isShared {
                return "Shared Places"
            } else {
                return "Private Places"
            }
        default:
            return "Shared Places"
        }
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
            fatalError("Can't edit sections like that")
        }
    }
}

extension PlaceViewController: BlurBackgroundDelegate {
    func dismissBlur() {
        self.mainTableView.reloadData()
        UIView.animate(withDuration: 0.2) {
            self.blurredBackgroundView.alpha = 0
        }
        
    }
}

// MARK: - Menu Setup
extension PlaceViewController {
    
    private func setupMenu(){
        UIApplication.shared.keyWindow?.addSubview(menuView)
        menuView.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width / 2, height: view.frame.height)
    }
    
}

