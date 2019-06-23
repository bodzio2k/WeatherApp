//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit
import CoreLocation

class FavouritesViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: IBActions
    @IBAction func changeDegreeScale(_ sender: UITapGestureRecognizer) {
        Globals.degreeScale = (Globals.degreeScale == .fahrenheit ? .celsius : .fahrenheit)
        getCurrentTemps()
        tableView.reloadData()
    }
    
    @IBAction func addLocation(_ sender: UITapGestureRecognizer) {
        guard let destVC = storyboard!.instantiateViewController(withIdentifier: "LocationsViewController") as? LocationsViewController else {
            fatalError("Cannot get destintation VC...")
        }
        
        present(destVC, animated: true, completion: nil)
    }
    
    //MARK: Properties
    var selectedLocation: Location?
    var favourites: FavouritesProtocol?
    var locations: [Location]?
    var selectedItemIndex = 0
    let dateFormatter = DateFormatter()
    var networkClient: NetworkClientProtocol?
    var currentTemps: [Int:Int] = [:]
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FavouriteTableViewCell")
        
        dateFormatter.timeStyle = .short
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favourites?.load()
        getCurrentTemps()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .denied {
            print("authorizationStatus is .denied...")
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("significantLocationChangeMonitoringAvailable is false...")
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" == "backToHome" {
            let destVC = segue.destination as! HomeViewController
            
            destVC.scrollToFavourite = selectedItemIndex
        }
    }
    
    func getCurrentTemps() {
        guard let favourites = favourites else {
            fatalError("Cannot get favourites...")
        }
        
        for fav in favourites.items {
            OperationQueue.main.addOperation {
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                
                self.networkClient?.fetchWeatherForecast(for: coordinates, units: Globals.degreeScale.toString(), completion: {(currently, hourly, daily, error) in
                    if let error = error {
                        print("Cannot ger current weather for \(fav.city)...\(error.localizedDescription)...")
                    }
                    
                    self.currentTemps[fav.id] = currently!.temperature
                    
                    print("Getting current temp for \(fav.city)...")
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favourites?.items.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < favourites?.items.count ?? 0 {
            let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
            let location = favourites!.items[indexPath.row]
            let timeZoneIdUnescaped = (location.timeZoneId ?? "GMT").replacingOccurrences(of: "\\", with: "")
            let timeZone = TimeZone(identifier: timeZoneIdUnescaped)
            let currentDate = Date()
            
            dateFormatter.timeZone = timeZone
            
            favoriteCell.hour.text = dateFormatter.string(from: currentDate)
            favoriteCell.location.text = location.city
            
            if let currentTemp = currentTemps[location.id] {
                favoriteCell.currentTemp.text = String(currentTemp) + "°"
            }
            else
            {
                favoriteCell.currentTemp.text = "--" + "°"
            }
            
            if location.id == Int.min {
                favoriteCell.currentLocationIndicator.isHidden = false
            }
            
            return favoriteCell
        }
        else
        {
            guard let addLocationCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell") as? FavouriteOptionsTableViewCell else {
                fatalError("Cannot get FavouriteOptionsTableViewCell..." )
            }
            let celsiusSelected, fahrenheitSelected, celsiusUnselected, fahrenheitUnselected: NSAttributedString
            let resultText = NSMutableAttributedString(string: "")
            
            celsiusSelected = NSAttributedString(string: "C°", attributes: Globals.highlightedAttrs)
            fahrenheitUnselected = NSAttributedString(string: "\\F°", attributes: Globals.normalAttrs)
            
            celsiusUnselected = NSAttributedString(string: "C°", attributes: Globals.normalAttrs)
            fahrenheitSelected = NSAttributedString(string: "\\F°", attributes: Globals.highlightedAttrs)
            
            if Globals.degreeScale == .celsius {
                resultText.append(celsiusSelected)
                resultText.append(fahrenheitUnselected)
            }
            else
            {
                resultText.append(celsiusUnselected)
                resultText.append(fahrenheitSelected)
            }
            
            addLocationCell.degreeScaleIndicator.attributedText = resultText
            
            return addLocationCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowCount = favourites?.items.count ?? 1
        
        if rowCount == indexPath.row {
            return
        }
        
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

extension FavouritesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[0]
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            if let error = error {
                print("Failed to decore lastLocation: \(error.localizedDescription)...")
                
                return
            }
            
            if let newPlacemark = placemarks?[0], let locality = newPlacemark.locality {
                print("Received new location \(locality)...")
            }
        }
    }
}
