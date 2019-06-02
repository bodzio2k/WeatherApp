//
//  HomeViewController
//  Weather App
//
//  Created by Krzysztof Podolak on 27/11/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Swinject
import CoreLocation

class HomeViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var currentLocation: Location? {
        didSet (newValue) {
            currentForecast = Forecast(for: newValue ?? favourites!.items[0])
        }
    }
    var currentForecast: Forecast?
    var favourites: FavouritesProtocol?
    var scrollToFavourite = 0
    var locationManager = CLLocationManager()
    var dateFormatter = DateFormatter()
    var networkClient: NetworkClientProtocol?
    var prefetched: [Int:Currently?] = [:]
    var hourly: [Hourly]?
    
    override func viewDidLoad() {
        var nibCell: UINib?
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(favouritesButton)
            
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.prefetchDataSource = self
        
        dateFormatter.timeStyle = .medium
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        nibCell = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        hourlyCollectionView.register(nibCell, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        
        nibCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouritesCollectionView.register(nibCell, forCellWithReuseIdentifier: "FavouriteCollectionViewCell")
        
        let fl = favouritesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        fl?.itemSize.width = self.view.frame.width - 16
        fl?.minimumLineSpacing = 1
        
        let rowHeight = CGFloat(40.00)
        dailyTableView.rowHeight = rowHeight
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favourites?.load()
        let favouritesCount = favourites?.items.count ?? 0
        
        if favouritesCount == 0 {
            if !CLLocationManager.locationServicesEnabled() {
                print("Cannot obtain current location...")
                
                return
            }
            
            DispatchQueue.main.async {
                print("Getting current location: ", self.dateFormatter.string(from: Date()))
                self.locationManager.requestLocation()
            }
        }
        else
        {
            favouritesCollectionView.reloadData()
            favouritesCollectionView.scrollToItem(at: IndexPath(item: scrollToFavourite, section: 0), at: .right, animated: true)
        
            currentLocation = favourites?.items[scrollToFavourite]
        }
    }
    
    //MARK: Navigation
    @IBAction func onShowFavorites() {
        self.performSegue(withIdentifier: "showFavorites", sender: self)
    }
    
    @IBAction func unwindBackToHome(segue: UIStoryboardSegue) {
        return
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.maxNextDaysCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
        
        /*
        cell.dayOfWeek.text = row?.dayOfWeek
        cell.conditions.image = row?.conditions
        cell.maxTemp.text = (row?.maxTemp ?? "--") + "°"
        cell.minTemp.text = (row?.minTemp ?? "--") + "°"
        */
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // HOURLY
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
            
            if let item = self.hourly?[indexPath.row] {
                cell.icon.image = item.image
                dateFormatter.timeStyle = .short
                cell.now.text = dateFormatter.string(from: item.time).replacingOccurrences(of: ":00", with: "")
                cell.temp.text = String(item.temperature) + "°"
                cell.icon.image = item.image
            }
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.1
            
            return cell
        }
        // FAVOURITES COLLECTION VIEW
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
            
            guard let fav = favourites?.items[indexPath.row] else {
                fatalError("Cannot get fav...")
            }
            
            if let currently = prefetched[fav.id] {
                cell.configure(with: currently, for: fav)
            }
            else
            {
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                
                networkClient?.fetchWeatherForecast(for: coordinates, completion: { (currently, hourly, daily, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    
                    self.prefetched[fav.id] = currently!
                    self.hourly = hourly!
                    
                    collectionView.reloadItems(at: [indexPath])
                    cell.configure(with: currently, for: nil)
                })
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var rc = 0
        
        if collectionView == hourlyCollectionView {
            return Globals.maxHourlyCount
        }
        
        if collectionView == favouritesCollectionView {
            rc = favourites?.items.count ?? 1
        }
        
        return rc
    }
 
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == favouritesCollectionView {
            let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            
            self.currentLocation = self.favourites!.items[currentIndex]
            
            return
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        let timestamp = dateFormatter.string(from: Date())
        var currentPlacemark: CLPlacemark?
        
        geocoder.reverseGeocodeLocation(locations[0]) { (placemark, error) in
            if let error = error {
                print("Cannot retrieve placemark: \(timestamp); \(error.localizedDescription)")
                return
            }
            
            guard (self.favourites?.items.count ?? 0) == 0 else {
                return
            }
                
            currentPlacemark = placemark![0]
            let locality = currentPlacemark?.locality ?? "none"
            
            let initialLocation = Location()
            
            initialLocation.city = locality
            initialLocation.longitude = locations[0].coordinate.longitude
            initialLocation.latitude = locations[0].coordinate.latitude
            initialLocation.id = Int.min
            initialLocation.updateTimezoneAbbr {
                self.favourites?.add(initialLocation)
                self.favourites?.save()
                self.favouritesCollectionView.reloadData()
                
                guard let fav = self.favourites?.items[self.scrollToFavourite] else {
                    fatalError("Error while getting fav...")
                }
                
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                self.networkClient?.fetchWeatherForecast(for: coordinates, completion: {(currently, hourly, daily, error) in
                    if let error = error {
                        fatalError("Error occured while getting forecast... \(error.localizedDescription)...")
                    }
                    
                    self.prefetched[0] = currently!
                })
                
                print("Placemark retrieved: \(timestamp); \(locality)")
            }
        }
            
        self.hourlyCollectionView.reloadData()
        self.dailyTableView.reloadData()
        
        print("didUpdateLocations: ", dateFormatter.string(from: Date()))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: ", dateFormatter.string(from: Date()), "; ", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization: \(status.rawValue)...")
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func getCurrentLocation() {
        return
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView != favouritesCollectionView { return }
        
        let rows = indexPaths.compactMap { i in return i.row }
        print("Prefetching rows \(rows)...")
        
        for i in rows {
            let fav = favourites!.items[i]
            let coordinate = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.networkClient?.fetchWeatherForecast(for: coordinate, completion: { (currently, hourly, daily, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    
                    print("Prefetched weather for row \(i)...")
                    
                    self.prefetched[fav.id] = currently!
                    self.hourly = hourly!
                })
            }
            
        }
    }

}
