//
//  SearchTableViewController.swift
//  Move
//
//  Created by Jake Gray on 4/27/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import CoreData

protocol SearchTableViewControllerDelegate: class {
    func present(view: UIViewController)
}

class SearchTableViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SearchTableViewControllerDelegate?
    
    // MARK: - Properties
    let cellIdentifier = "searchCell"
    var filteredItems: [Item] = []
    var filteredBoxes: [Box] = []
    
    let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    // MARK: - Life Cycle
    
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
        
        

        if indexPath.section == 0 {
            if filteredItems.count > 0 {
                let item = filteredItems[indexPath.row]
                cell.setupCell(box: nil, item: item)
            } else {
                cell.setNoResults(icon: #imageLiteral(resourceName: "ItemIcon"))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0 :
            if filteredItems.count > 0 {
                let item = filteredItems[indexPath.row]
                
                let itemDetailVC = ItemDetailViewController()
                itemDetailVC.item = item
                itemDetailVC.box = item.box!
                delegate?.present(view: itemDetailVC)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 1 :
            if filteredBoxes.count > 0 {
                let box = filteredBoxes[indexPath.row]
                
                let itemVC = ItemViewController()
                itemVC.box = box
                delegate?.present(view: itemVC)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            fatalError("Invalid Cell")
        }
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

extension SearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
