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
    var networkClient: NetworkClientProtocol?
    var searchFor: String!
    let highlightedAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
    let normalAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
    var detailText: String?
    
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
        let location = locations![indexPath.row]
        let locationName = location.city
        let highlightedPart = NSAttributedString(string: String(locationName.prefix(searchFor.count)), attributes: highlightedAttrs)
        var suffixLength = locationName.count - searchFor.count
        suffixLength = suffixLength < 0 ? 0 : suffixLength
        let otherPart = NSAttributedString(string: String(locationName.suffix(suffixLength)), attributes: normalAttrs)
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(highlightedPart)
        attributedText.append(otherPart)
        
        cell.textLabel?.attributedText = attributedText
        
        if let region = location.region {
            detailText = region + ", " + location.country
        }
        else
        {
            detailText = location.country
        }
        
        cell.detailTextLabel?.text = detailText!
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = locations?.count ?? 0
        
        return rc
    }
}

extension LocationsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchFor = searchController.searchBar.text ?? ""
        
        if searchFor.count < 3 || 1 == 0 {
            locations = []
            tableView.reloadData()
            
            return				
        }
        
        networkClient?.fetchCities(by: searchFor, completion: { (locations, error) in
            if let locations = locations {
                self.locations = locations
                self.tableView.reloadData()
            }
        })
    }
}
