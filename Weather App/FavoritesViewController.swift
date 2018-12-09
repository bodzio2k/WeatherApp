//
//  FavoritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cities = ["New Your", "Miami"]
    
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
        var favoriteCell: UITableViewCell!
        
        if indexPath.row < cities.count {
            favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell
        }
        else
        {
            favoriteCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell")
        }
        
        return favoriteCell
    }
}
