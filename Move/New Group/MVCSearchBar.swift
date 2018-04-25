//
//  MVCSearchBar.swift
//  Move
//
//  Created by Jake Gray on 4/25/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension MoveViewController: UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // do some stuff
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        filteredItems = candies.filter({( candy : Candy) -> Bool in
//            return candy.name.lowercased().contains(searchText.lowercased())
//        })
//
//        tableView.reloadData()
//    }
}
