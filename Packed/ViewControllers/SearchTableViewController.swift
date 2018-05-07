//
//  SearchTableViewController.swift
//  Move
//
//  Created by Jake Gray on 4/27/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    let cellIdentifier = "searchCell"
    var filteredItems: [Item] = []
    var filteredBoxes: [Box] = []
    
    let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(searchTableView)
        
        setupTable()
    }
    
    private func setupTable(){
        searchTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Items"
        } else {
            return "Boxes"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemHeader = UIView()
        itemHeader.backgroundColor = secondaryColor
        itemHeader.layer.borderWidth = 1
        itemHeader.layer.borderColor = mainColor.cgColor
        let itemHeaderLabel = UILabel()
        itemHeaderLabel.text = "Items"
        itemHeaderLabel.textColor = mainColor
        itemHeaderLabel.font = UIFont.boldSystemFont(ofSize: 22)
        itemHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        itemHeader.addSubview(itemHeaderLabel)
        itemHeaderLabel.centerYAnchor.constraint(equalTo: itemHeader.centerYAnchor).isActive = true
        itemHeaderLabel.leadingAnchor.constraint(equalTo: itemHeader.leadingAnchor, constant: 16).isActive = true
        
        let boxHeader = UIView()
        boxHeader.backgroundColor = secondaryColor
        boxHeader.layer.borderWidth = 1
        boxHeader.layer.borderColor = mainColor.cgColor
        let boxHeaderLabel = UILabel()
        boxHeaderLabel.text = "Boxes"
        boxHeaderLabel.textColor = mainColor
        boxHeaderLabel.font = UIFont.boldSystemFont(ofSize: 22)
        boxHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        boxHeader.addSubview(boxHeaderLabel)
        boxHeaderLabel.centerYAnchor.constraint(equalTo: boxHeader.centerYAnchor).isActive = true
        boxHeaderLabel.leadingAnchor.constraint(equalTo: boxHeader.leadingAnchor, constant: 16).isActive = true
        
        if section == 0 {
            return itemHeader
        } else {
            return boxHeader
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return filteredItems.count
        } else {
            return filteredBoxes.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else {return SearchTableViewCell()}

        if indexPath.section == 0 {
            let item = filteredItems[indexPath.row]
            cell.update(withTitle: item.name!, image: #imageLiteral(resourceName: "ItemIcon"))
        } else {
            let box = filteredBoxes[indexPath.row]
            cell.update(withTitle: box.name!, image: #imageLiteral(resourceName: "BoxIcon"))
        }
        

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
        
        let itemFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
        itemFetchRequest.predicate = predicate
        
        let boxFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Box")
        boxFetchRequest.predicate = predicate
        
        do {
            filteredBoxes = try CoreDataStack.context.fetch(boxFetchRequest) as! [Box]
            filteredItems = try CoreDataStack.context.fetch(itemFetchRequest) as! [Item]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        
        searchTableView.reloadData()
    }
}
