//
//  FavoritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cities = ["New York", "Miami", "Los Angeles", "San Francisco", "Cupertino"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FavoriteCell")
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < cities.count {
            let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
            favoriteCell.hour.text = "23:59"
            favoriteCell.location.text = cities[indexPath.row]
            favoriteCell.currentTemp.text = "21°"
            
            return favoriteCell
        }
        else
        {
            let addLocationCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell")!
            return addLocationCell
        }
    }
}
