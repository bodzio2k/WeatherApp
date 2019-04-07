//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Swinject

class FavouritesViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var selectedLocation: Location?
    var favourites: FavouritesProtocol?
    var locations: LocationsProtocol?
    //var favouritesCount: Int!
    var selectedItemIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favourites?.load()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" == "backToHome" {
            
            let destVC = segue.destination as! HomeViewController
            
            destVC.currentLocation = selectedLocation
            destVC.scrollToFavourite = selectedItemIndex
        }
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favourites?.items.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < favourites?.items.count ?? 0 {
            let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            let location = favourites!.items[indexPath.row]
            
            favoriteCell.hour.text = "23:59"
            favoriteCell.location.text = location.name
            favoriteCell.currentTemp.text = "21°"
            
            return favoriteCell
        }
        else
        {
            let addLocationCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell")!
            
            return addLocationCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId = favourites!.items[indexPath.row].id
        selectedLocation = locations!.getLocation(by: selectedId)
        selectedItemIndex = indexPath.row
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let itemsCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0) ?? 0
        
        if indexPath.row == 0 || indexPath.row == itemsCount - 1 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = favourites?.delete(at: indexPath.row, commit: true)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rc: CGFloat!
        
        if indexPath.row == favourites!.items.count + 1 {
            rc = 120.00
        }
        
        rc = 90
        
        return rc
    }
}

