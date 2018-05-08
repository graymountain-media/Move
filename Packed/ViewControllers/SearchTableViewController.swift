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
        tableView.rowHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(searchTableView)
        
        setupTable()
    }
    
    private func setupTable(){
        searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredItems.count == 0 ? 1 : filteredItems.count
        } else {
            return filteredBoxes.count == 0 ? 1 : filteredBoxes.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else {return SearchTableViewCell()}
        
        print("FilteredItems: \(filteredItems.count)")
        print("FilteredBoxes: \(filteredBoxes.count)")

        if indexPath.section == 0 {
            if filteredItems.count > 0 {
                let item = filteredItems[indexPath.row]
                cell.setupCell(box: nil, item: item)
            } else {
                cell.setNoResults(icon: #imageLiteral(resourceName: "ItemIcon"))
                print("No Items")
            }
        } else {
            if filteredBoxes.count > 0 {
                let box = filteredBoxes[indexPath.row]
                cell.setupCell(box: box, item: nil)
            } else {
                cell.setNoResults(icon: #imageLiteral(resourceName: "BoxIcon"))
            }
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
