//
//  LocationsViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var locations: [Location]?
    var favourites: FavouritesProtocol?
    var geoDBClient: GeoDBClientProtocol?
    
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
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let l = locations![indexPath.row]
        
        cell.textLabel?.text = l.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations![indexPath.row]
        
        favourites!.add(location)
        favourites!.save()
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let rc = 1//locations?.distinctCountries.count ?? 0
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = locations?.count ?? 0
        
        return rc
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rc = locations!.distinctCountries[section]
        
        return rc
    }*/
}

extension LocationsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
}

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchFor = searchController.searchBar.text ?? ""
        
        if searchFor.count < 3 {
            locations = []
            tableView.reloadData()
            
            return				
        }
        
        geoDBClient?.fetchCities(by: searchFor, completion: { (locations, error) in
            if let locations = locations {
                self.locations = locations
                self.tableView.reloadData()
            }
        })
    }
}
