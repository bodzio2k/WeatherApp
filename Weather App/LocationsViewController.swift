//
//  LocationsViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    //MARK: Properties
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    
    func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "SEARCH"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        configureSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchFor = searchController.searchBar.text ?? ""
        
        getFakeData().filter(by: searchFor)
        
        tableView.reloadData()
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let l = getFakeData().getLocation(at: indexPath)
        
        cell.textLabel?.text = l.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = getFakeData().getLocation(at: indexPath)
        
        getFakeData().favourites?.append(location)
        getFakeData().saveFavorites()
        
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let rc = getFakeData().distinctCountries.count
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = getFakeData().numberOfRowsInSection(section)
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rc = getFakeData().distinctCountries[section]
        
        return rc
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
}
