//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        performSegue(withIdentifier: "backToHome", sender: self)
    }
}
