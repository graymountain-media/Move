//
//  MainViewController.swift
//  Move
//
//  Created by Jake Gray on 4/30/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PackedTableViewCellDelegate {
   
    // MARK: - Properties
    let cellIdentifier = "mainCell"
    
    let data = ["home 1", "home2"]
    
    let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = offWhite
        return tableView
    }()
    
    let leftNavButton: UIBarButtonItem = {
        let navButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(optionsButtonPressed))
        return navButton
    }()
    
    let rightNavButton: UIBarButtonItem = {
        let navButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        return navButton
    }()
    
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "You don't have any Places yet."
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Tap '+' to add a new Place."
        label.font = label.font.withSize(16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchController: UISearchController = {
        let resultsController = SearchTableViewController()
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = mainColor
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.placeholder = "Search Boxes/Items"
        searchController.searchBar.layer.borderWidth = 0
        searchController.dimsBackgroundDuringPresentation =  true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = textFieldColor
        
        return searchController
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if data.count != 0 {
            noDataLabel.isHidden = true
            instructionLabel.isHidden = true
        }
        
        self.title = "Places"
        view.backgroundColor = offWhite
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(optionsButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))

        mainTableView.register(PackedTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
        definesPresentationContext = true
        
        setupTableView()
        setupLabels()
    }
    
    // MARK: - View Setup
    
    private func setupTableView(){
        view.addSubview(mainTableView)

        mainTableView.tableHeaderView = searchController.searchBar
        
        mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

    }
    
    private func setupLabels(){
        
        view.addSubview(noDataLabel)
        view.bringSubview(toFront: noDataLabel)
        view.addSubview(instructionLabel)

        noDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        noDataLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        noDataLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        noDataLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        instructionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 24).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
    }
    
    // MARK: NavBar Buttons
    
    @objc private func optionsButtonPressed() {
        
    }
    
    @objc private func addButtonPressed() {
        print("Add button pressed")
        let newPlaceViewController = NewPlaceViewController()
        navigationController?.pushViewController(newPlaceViewController, animated: true)
    }
    
    func cellOptionsButtonPressed(sender: UITableViewCell) {
        
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        let item = data[indexPath.row]
        cell.setupCell(name: item, image: #imageLiteral(resourceName: "HomeIcon"))
        
        return cell
    }
}
