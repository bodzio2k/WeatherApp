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
    var locations = Array<Location>()
    var favourites: FavouritesProtocol?
    var networkClient: NetworkClientProtocol?
    var searchFor = ""
    var detailText: String?
    var lastError: Error?
    var errorOccured = false
    
    func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
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
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !errorOccured else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessageCell", for: indexPath)
             
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = lastError!.localizedDescription
             
            return cell
        }
        
        guard locations.count != 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessageCell", for: indexPath)
            let text: String
            
            switch searchFor.count {
            case 0:
                text = ""
            case 0..<Globals.searchForMinCharacterCount:
                text = "Validating city."
            default:
                text = "No results found."
            }
            
            cell.contentView.backgroundColor = .systemBackground
            cell.textLabel?.textColor = .label
            cell.textLabel?.text = text
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = locations[indexPath.row]
        let locationName = location.city
        let locationNamePrefix = String(locationName.prefix(searchFor.count))
        let highlightedPart = NSMutableAttributedString(string: locationNamePrefix, attributes: Globals.highlightedAttrs)
        var suffixLength = locationName.count - searchFor.count
        suffixLength = suffixLength < 0 ? 0 : suffixLength
        let locationNameSuffix = String(locationName.suffix(suffixLength))
        let otherPart = NSMutableAttributedString(string: locationNameSuffix, attributes: Globals.normalAttrs)
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
        let completion = {
            let location = self.locations[indexPath.row]
            
            self.favourites!.add(location)
            self.favourites!.save()

            self.performSegue(withIdentifier: "unwindBackToFavourites", sender: self)
        }
        
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: completion)
            
            return
        }
        
        completion()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !errorOccured else {
            return 1
        }
        
        let rc = locations.count > 0 ? locations.count : 1
        
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
        
        if searchFor.count < Globals.searchForMinCharacterCount {
            errorOccured = false
            
            locations = []
            tableView.reloadData()
            
            return				
        }
        
        networkClient?.fetchCities(by: searchFor, completion: { (locations, error) in
            if let error = error {
                Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); \(error.localizedDescription)")
                
                self.errorOccured = true
                self.lastError = error
            }
            
            if let locations = locations {
                self.locations = locations
                
                self.errorOccured = false
            }
            
            self.tableView.reloadData()
        })
    }
}
