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
    var fakeData = FakeData()
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
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchFor = searchController.searchBar.text ?? ""
        
        fakeData.filter(by: searchFor)
        
        tableView.reloadData()
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let l = fakeData.getLocation(at: indexPath)
        
        cell.textLabel?.text = l.name
        
        return cell
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let rc = fakeData.distinctCountries.count
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = fakeData.numberOfRowsInSection(section)
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rc = fakeData.distinctCountries[section]
        
        return rc
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
}
