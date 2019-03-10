//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Swinject

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var selectedLocation: Location?
    var favourites: FavouritesProtocol?
    var locations: LocationsProtocol?
    
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
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = favourites!.items.count ?? 0
        
        return rc + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < favourites!.items.count {
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
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" == "backToHome" {
            
            let destVC = segue.destination as! HomeViewController
        
            destVC.currentLocation = selectedLocation
        }
    }
}
