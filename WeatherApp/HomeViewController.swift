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
            hourlyCollectionView.reloadData()
            dailyTableView.reloadData()
            
            return
        }
    }
    var currentForecast: Forecast?
    var favourites: FavouritesProtocol?
    var scrollToFavourite = 0
    var locations: [Location]?
    var locationManager = CLLocationManager()
    var dateFormatter = DateFormatter()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favourites?.load()
        let favouritesCount = favourites?.items.count ?? 0
        
        if favouritesCount == 0 {
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
            //currentForecast = Forecast(for: currentLocation!)
        }
        
        hourlyCollectionView.reloadData()
        dailyTableView.reloadData()
        
        return
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
        
        let row = currentForecast?.nextDays[indexPath.row]
        
        cell.dayOfWeek.text = row?.dayOfWeek
        cell.conditions.image = row?.conditions
        cell.maxTemp.text = (row?.maxTemp ?? "--") + "°"
        cell.minTemp.text = (row?.minTemp ?? "--") + "°"
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
            
            let row = currentForecast?.today[indexPath.row]
            
            cell.icon.image = row?.currentConditions
            cell.now.text = row?.currentHour
            cell.temp.text = row?.currentTemp
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.1
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
            let fav: Location = favourites!.items[indexPath.row]
            
            cell.currentConditions.text = "foggy"
            cell.currentCity.text = fav.city
            cell.currentTemp.text = "22°"
            
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
            
            currentPlacemark = placemark![0]
            let locality = currentPlacemark?.locality ?? "none"
            
            var initialLocation = Location()
            let newId = UUID()
            initialLocation.city = locality
            initialLocation.longitude = locations[0].coordinate.longitude
            initialLocation.latitude = locations[0].coordinate.latitude
            initialLocation.id = newId.uuidString
            self.favourites?.add(initialLocation)
            self.favourites?.save()
            
            self.favouritesCollectionView.reloadData()
            self.hourlyCollectionView.reloadData()
            self.dailyTableView.reloadData()
            
            print("Placemark retrieved: \(timestamp); \(locality)")
        }
        
        print("didUpdateLocations: ", dateFormatter.string(from: Date()))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: ", dateFormatter.string(from: Date()), "; ", error.localizedDescription)
    }
}
