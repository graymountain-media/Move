//
//  MainViewController.swift
//  Move
//
//  Created by Jake Gray on 4/30/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PackedTableViewCellDelegate {
   
    var viewTitle = "" {
        didSet {
            self.title = viewTitle
        }
    }
    // MARK: - Properties
    let cellIdentifier = "mainCell"
    
    let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = offWhite
        return tableView
    }()
    
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = offWhite
        label.textAlignment = .center
        label.text = "You don't have any (type) yet."
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Tap '+' to add a new (type)."
        label.font = label.font.withSize(16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultsController = SearchTableViewController()
    var searchController = UISearchController()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewTitle
        view.backgroundColor = offWhite
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        mainTableView.register(PackedTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        resultsController.delegate = self
        
        setupSearchController()
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
        
        setupTableView()
        setupLabels()
        updateView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    // MARK: - Methods
    
    func updateView(){
        
    }
    
    // MARK: - View Setup
    
    private func setupSearchController(){
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .white
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.placeholder = "Search Boxes/Items"
        searchController.searchBar.layer.borderWidth = 0
        searchController.dimsBackgroundDuringPresentation = true
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        navigationItem.searchController?.searchBar.barStyle = UIBarStyle.blackTranslucent
    }
    
    private func setupTableView(){
        view.addSubview(mainTableView)
        
        mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

    }
    
    private func setupLabels(){
        
        view.addSubview(noDataLabel)
        view.bringSubview(toFront: noDataLabel)
        view.addSubview(instructionLabel)

        noDataLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noDataLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        instructionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 24).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
    }
    
    // MARK: NavBar Buttons
    
    @objc private func optionsButtonPressed() {
        
    }
    
    @objc func addButtonPressed() {
    }
    
    func cellOptionsButtonPressed(sender: UITableViewCell) {
        
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackedTableViewCell else {return PackedTableViewCell()}
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewTitle
    }
 
}

extension MainViewController: SearchTableViewControllerDelegate {
    func present(view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
        searchController.isActive = false
    }
    
    
}

