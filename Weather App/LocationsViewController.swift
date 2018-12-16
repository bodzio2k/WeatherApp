//
//  LocationsViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var fakeData = FakeData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let l = fakeData.getLocation(at: indexPath)
        
        cell.textLabel?.text = l.name
        
        return cell
    }
    
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
}
