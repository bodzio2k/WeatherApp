//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFakeData().loadFavorites()
        tableView.reloadData()
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rc = (getFakeData().favourites?.count ?? 0) + 1
        
        return rc
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < getFakeData().favourites?.count ?? 0 {
            let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            let location = getFakeData().favourites?[indexPath.row]
            
            favoriteCell.hour.text = "23:59"
            favoriteCell.location.text = location?.name
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
        let selectedId = getFakeData().favourites?[indexPath.row].id ?? -1
        selectedLocation = getFakeData().getLocation(byId: selectedId)
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" == "backToHome" {
            
            let destVC = segue.destination as! HomeViewController
        
            destVC.currentLocation = selectedLocation
        }
    }
}
