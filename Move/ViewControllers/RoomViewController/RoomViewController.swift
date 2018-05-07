//
//  RoomViewController.swift
//  Move
//
//  Created by Jake Gray on 4/25/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class RoomViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate{
    
    var space: Place?
    
    var RoomsFetchedResultsController: NSFetchedResultsController<Room> = NSFetchedResultsController()

    // MARK: - Properties
    
    let cellIdentifier = "RoomCell"
    var inputStackViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // Body
    
    let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        return tableView
    }()
    
    let noEntitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "You do not have rooms set up."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.isHidden = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Footer
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add New Room", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(activateAddView), for: .touchUpInside)
        return button
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitAdd), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0.0
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        textField.alpha = 0.0
        textField.backgroundColor = .white
        textField.textColor = mainColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()
    
    let searchController: UISearchController = {
        let resultsController = SearchTableViewController()
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.barTintColor = mainColor
        searchController.searchBar.tintColor = .white
        searchController.searchBar.layer.borderWidth = 0
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.placeholder = "Search Boxes/Items"
        searchController.dimsBackgroundDuringPresentation =  false
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
    
    let addView: UIView = {
        let view = UIView()
        view.backgroundColor = secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var rightButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moreOptions"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.contentMode = .scaleAspectFill
        let navButton = UIBarButtonItem(customView: button)
        navButton.tintColor = mainColor
        return navButton
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        if let space = space {
            self.title = space.name
        }
        view.backgroundColor = mainColor
        self.navigationItem.rightBarButtonItem = rightButton
        
        setupFetchedResultsController()
        
        RoomsFetchedResultsController.delegate = self
        try? RoomsFetchedResultsController.performFetch()
        
        mainTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        nameTextField.delegate = self
        
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
        definesPresentationContext = true
        
        mainTableView.tableHeaderView = searchController.searchBar
        
        view.addSubview(mainTableView)
        view.addSubview(noEntitiesLabel)
        
        view.addSubview(addView)
        
        setupAddView()
        setupBody()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHideNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupFetchedResultsController(){
        
        
            let request: NSFetchRequest<Room> = Room.fetchRequest()
            
            var predicate = NSPredicate()
            
            if let space = self.space {
                predicate = NSPredicate(format: "space == %@", space)
            }
            // In the predicate, you need to check to see if the room's space is the same as the one above
            request.predicate = predicate
            
            let nameSort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSort]
            
            RoomsFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
       
    }
    
    func setupAddView(){
        addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addView.frame.size.height = 60;
        addView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        addView.addSubview(addButton)
        
        addButton.bottomAnchor.constraint(equalTo: addView.bottomAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: addView.topAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: addView.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: addView.trailingAnchor).isActive = true
        
        let inputStackView = UIStackView(arrangedSubviews: [nameTextField, submitButton])
        inputStackView.distribution = .fillEqually
        inputStackView.axis = .vertical
        inputStackView.spacing = 4
        inputStackView.backgroundColor = mainColor
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addView.addSubview(inputStackView)
        
        nameTextField.frame.size.height = 40
        
        inputStackView.topAnchor.constraint(equalTo: addView.topAnchor, constant: 8).isActive = true
        inputStackViewBottomConstraint = inputStackView.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -8)
        inputStackViewBottomConstraint.isActive = true
        inputStackView.leadingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 16).isActive = true
        inputStackView.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: -16).isActive = true
        
        addView.bringSubview(toFront: addButton)
        
    }
    
    func setupBody(){
        if (RoomsFetchedResultsController.sections?.count)! <= 0 {
            noEntitiesLabel.isHidden = false
        } else {
            noEntitiesLabel.isHidden = true
        }
        
        mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: addView.topAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        noEntitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noEntitiesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        noEntitiesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        noEntitiesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
    
}
