//
//  MoveViewController.swift
//  Move
//
//  Created by Jake Gray on 4/21/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class MoveViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate{
    
    required let testVariable = ""
    
    let SpacesFetchedResultsController: NSFetchedResultsController<Space> = {
        let request: NSFetchRequest<Space> = Space.fetchRequest()
        
         let nameSort = NSSortDescriptor(key: "name", ascending: true)
         request.sortDescriptors = [nameSort]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "name", cacheName: nil)
    }()
    
    // MARK: - Properties
    
    let cellIdentifier = "SpaceCell"
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
        label.text = "You do not have any spaces or homes set up."
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
        button.setTitle("Add New Space or Home", for: .normal)
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
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for item or box name..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = mainColor
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.barTintColor = mainColor
        searchController.searchBar.tintColor = .white
        searchController.searchBar.layer.borderWidth = 0
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.placeholder = "Search Boxes/Items"
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
        button.frame = CGRect(x: 0, y: 0, width: 8, height: 30)
        button.contentMode = .scaleAspectFill
        let navButton = UIBarButtonItem(customView: button)
        navButton.tintColor = mainColor
        return navButton
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Spaces"
        view.backgroundColor = mainColor
        self.navigationItem.rightBarButtonItem = rightButton
        
        SpacesFetchedResultsController.delegate = self
        try? SpacesFetchedResultsController.performFetch()
        
        mainTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        nameTextField.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation =  true
        definesPresentationContext = true
        
        mainTableView.tableHeaderView = searchController.searchBar
        
        view.addSubview(mainTableView)
        view.addSubview(noEntitiesLabel)
        
        view.addSubview(addView)
        view.addSubview(searchBar)
        
        setupAddView()
        setupBody()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHideNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func setupAddView(){
        addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addView.frame.size.height = 44;
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
        if (SpacesFetchedResultsController.sections?.count)! <= 0 {
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



