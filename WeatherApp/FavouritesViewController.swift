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
        Globals.lastRefreshTime = Globals.needToRefresh
        
        DispatchQueue.main.async {
            self.getCurrentTemps()
        }
    }
    
    //MARL: Properties
    var pendingOperations = 0
    
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
    var networkClient: NetworkClientProtocol?
    var currentTemps: [Int:Int] = [:]
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibCell = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FavouriteTableViewCell")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getCurrentTemps), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pendingOperations = 0
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Globals.lastRefreshTime = Globals.needToRefresh
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" == "backToHome" {
            let destVC = segue.destination as! HomeViewController
            
            destVC.scrollToFavourite = selectedItemIndex
        }
    }
    
    @objc func getCurrentTemps() {
        guard let favourites = favourites else {
            fatalError("Cannot get favourites...")
        }
        
        if let lastRefreshTime = Globals.lastRefreshTime, Date() < Date(timeInterval: Globals.minRefreshInterval, since: lastRefreshTime) {
            print("No need to refresh...")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tableView.refreshControl?.endRefreshing()
            })
            
            return
        }
        
        
        for fav in favourites.items {
            pendingOperations += 1
            
            OperationQueue.main.addOperation {
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                
                self.networkClient?.fetchWeatherForecast(for: coordinates, units: Globals.degreeScale.toString(), completion: {(currently, hourly, daily, error) in
                    if let error = error {
                        fatalError("Cannot ger current weather for \(fav.city)...\(error.localizedDescription)...")
                    }
                    
                    self.currentTemps[fav.id] = currently!.temperature
                    
                    print("Getting current temp for \(fav.city)...")
                    
                    self.pendingOperations += -1
                    
                    if self.pendingOperations == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { () -> Void in
                            self.tableView.refreshControl?.endRefreshing()
                            self.tableView.reloadData()
                     
                            print("endRefreshing...")
                            
                            Globals.lastRefreshTime = Date()
                        })
                    }
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
            let authorizationStatus = CLLocationManager.authorizationStatus()
            
            favoriteCell.hour.text = Date().getCurrentTimeString(in: location.timeZoneId)
            favoriteCell.location.text = location.city
            
            if let currentTemp = currentTemps[location.id] {
                favoriteCell.currentTemp.text = String(currentTemp) + "°"
            }
            else
            {
                favoriteCell.currentTemp.text = "--" + "°"
            }
            
            let isCurrentLocationIndicatorVisible = location.id == Int.min && authorizationStatus == .authorizedWhenInUse
            favoriteCell.currentLocationIndicator.isHidden = !isCurrentLocationIndicatorVisible
            
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
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if (indexPath.row == 0 && authorizationStatus == .authorizedWhenInUse) || indexPath.row == itemsCount - 1 {
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
        print("\(type(of: self)) didUpdateLocations...")
        
        let lastLocation = locations[0]
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            if let error = error {
                print("Failed to decore lastLocation: \(error.localizedDescription)...")
                
                return
            }
            
            if let newPlacemark = placemarks?[0] {
                let locality = newPlacemark.locality ?? "none"
                var favouritesCurrentLocation: Location?
                
                print("Received new location \(locality)...")
                
                if self.favourites!.items.count > 0 {
                    favouritesCurrentLocation = self.favourites!.items[0]
                    
                    if (favouritesCurrentLocation!.city) == locality {
                        return
                    }
                }
                
                let newLocation = Location()
                
                newLocation.city = locality
                newLocation.country = newPlacemark.country ?? "none"
                newLocation.latitude = lastLocation.coordinate.latitude
                newLocation.longitude = lastLocation.coordinate.longitude
                newLocation.id = Int.min
                newLocation.updateTimeZoneId {
                    newLocation.timeZoneId = newPlacemark.timeZone?.identifier
                    self.favourites!.delete(id: Int.min, commit: true)
                    self.favourites!.insert(newLocation, at: 0)
                    self.favourites!.save()
                    self.getCurrentTemps()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(type(of: self)) didChangeAuthorization: \(status.rawValue)...")
        
        /*guard favourites!.items.count < 1 || status == .authorizedWhenInUse else {
            print("No need to reload first item in the tableView. Exiting...")
            
            return
        }*/
        
        let firstItem = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [firstItem], with: .fade)
    }
}
