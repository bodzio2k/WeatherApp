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
    //MARK: IBOutlets
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    //MARK: Actions
    @IBAction func goToFavouritesView(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showFavorites", sender: self)
    }
    
    //MARK: Properties
    var favourites: FavouritesProtocol?
    var scrollToFavourite = 0
    var locationManager = CLLocationManager()
    var dateFormatter = DateFormatter()
    var networkClient: NetworkClientProtocol?
    var prefetched: [Int:Currently?] = [:]
    var prefetchedHourly: [Int:[Hourly]?] = [:]
    var hourly: [Hourly]?
    var daily: [Daily]?
    var prefetchedDaily: [Int:[Daily]?] = [:]
    var lastFavouriteIndex: Int = 0
    var lastSelectedDegreeScale: Globals.DegreeScale!
    var currentLocationTimeZoneId: String?
    var separatorLineWidth: CGFloat = 0
    var errorOccured = false
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        var nibCell: UINib?
        super.viewDidLoad()
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.contentInsetAdjustmentBehavior = .never
        hourlyCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.prefetchDataSource = self
    
        dateFormatter.timeStyle = .medium
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 3000.0 //meters
        
        nibCell = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        hourlyCollectionView.register(nibCell, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        
        nibCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouritesCollectionView.register(nibCell, forCellWithReuseIdentifier: "FavouriteCollectionViewCell")
        
        let rowHeight = CGFloat(40.00)
        dailyTableView.rowHeight = rowHeight
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        lastSelectedDegreeScale = .celsius
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorOccured(_:)), name: Notification.Name(Globals.errorOccured), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: Notification.Name(Globals.didEnterForeground), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name(Globals.didEnterBackground), object: nil)
        
        reachability.whenUnreachable = { _ in
            var userInfo: [String: Any] = [:]
            
            userInfo["error"] = NSError(domain: "", code: -9999)
            NotificationCenter.default.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: userInfo)
            
            self.errorOccured = true
        }
        
        reachability.whenReachable = { _ in
            self.dismissAlertController()
            
            self.favouritesCollectionView.reloadData()
            
            self.errorOccured = false
        }
        
        try! reachability.startNotifier()
    }
    
    @objc func didEnterForeground() {
        invalidatePrefetched()
        favouritesCollectionView.reloadData()
        fadeIn()
    }
    
    @objc func didEnterBackground() {
        fadeOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favourites?.load()
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        let favouritesCount = favourites?.count ?? 0
        
        guard favouritesCount > 0 else {
            return
        }
        
        if lastSelectedDegreeScale != Globals.degreeScale || 1 == 1 {
            invalidatePrefetched()
            lastSelectedDegreeScale = Globals.degreeScale
        }
        
        favouritesCollectionView.reloadData()
        
        scrollTo(scrollToFavourite)
        
        pageControl.numberOfPages = favouritesCount
        pageControl.currentPage = scrollToFavourite
        
        lastFavouriteIndex = scrollToFavourite
        
        fadeIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.separatorLineWidth = self.view.frame.width * CGFloat(Globals.maxHourlyCount)
        hourlyCollectionView.addSeparator(at: .both, width: self.separatorLineWidth)
        let bottomSeparatorY = dailyTableView.frame.origin.y + dailyTableView.frame.height
        view.addSeparator(at: bottomSeparatorY)
    }
    
    func scrollTo(_ itemNo: Int) -> Void {
        let itemToReload = IndexPath(item: itemNo, section: 0)
        
        favouritesCollectionView.scrollToItem(at: itemToReload, at: .right, animated: true)
        
        if let currentFav = favourites?[scrollToFavourite] {
            currentLocationTimeZoneId = currentFav.timeZoneId ?? Globals.defaultTimeZoneId
            reloadDetails(for: currentFav)
        }
    }
    
    func invalidatePrefetched() {
        prefetched = [:]
        prefetchedHourly = [:]
        prefetchedDaily = [:]
    }
    
    func reloadDetails(for fav: Location) {
        if prefetchedHourly.keys.contains(fav.id) {
            self.hourly = prefetchedHourly[fav.id]!
            self.hourlyCollectionView.reloadData()
            
            let firstItem = IndexPath(item: 0, section: 0)
            self.hourlyCollectionView.scrollToItem(at: firstItem, at: .left, animated: false)
        }
        else
        {
            Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Cannot find prefeched hourly...")
        }
        
        if prefetchedDaily.keys.contains(fav.id) {
            self.daily = prefetchedDaily[fav.id]!
            self.dailyTableView.reloadData()
            
            let firstRow = IndexPath(item: 0, section: 0)
            self.dailyTableView.scrollToRow(at: firstRow, at: .top, animated: false)
        }
        else
        {
            Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Cannot find prefeched daily...")
            let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
            
            networkClient?.fetchWeatherForecast(for: coordinates, units: Globals.degreeScale.toString(), completion: { (_, hourly, daily, error) in
                if let hourly = hourly {
                    self.hourly = hourly
                }
                
                if let daily = daily {
                    self.daily = daily
                }
                
                self.hourlyCollectionView.reloadData()
                self.dailyTableView.reloadData()
            })
        }
    }
    
    //MARK: Navigation
    @IBAction func unwindBackToHome(segue: UIStoryboardSegue) {
        return
    }
    
    @IBAction func didChangeValue(_ sender: UIPageControl) {
        scrollTo(sender.currentPage)
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
        
        if let item = daily?[indexPath.row] {
            dateFormatter.dateFormat = "EEEE"
        
            cell.dayOfWeek.text = dateFormatter.string(from: item.time)
            cell.conditions.image = item.image
            cell.maxTemp.text = String(item.temperatureHigh) + "°"
            cell.minTemp.text = String(item.temperatureLow) + "°"
            
            cell.dayOfWeek.isHidden = false
            cell.conditions.isHidden = false
            cell.maxTemp.isHidden = false
            cell.minTemp.isHidden = false
        }
        
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
                let now = indexPath.row == 0 ? "Now" : Date().getFullHourString(from: item.time, in: self.currentLocationTimeZoneId)
                cell.now.text = now
                cell.temp.text = String(item.temperature) + "°"
                
                cell.icon.isHidden = false
                cell.now.isHidden = false
                cell.temp.isHidden = false
            }
            
            cell.layoutIfNeeded()
            
            return cell
        }
            
        // FAVOURITES COLLECTION VIEW
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
            
            guard let fav = favourites?[indexPath.row] else {
                fatalError("Cannot get fav for \(indexPath.row)...")
            }
            
            self.currentLocationTimeZoneId = fav.timeZoneId ?? Globals.defaultTimeZoneId
            
            if let currently = prefetched[fav.id] {
                cell.configure(with: currently, for: fav)
                self.hourly = prefetchedHourly[fav.id]!
                self.daily = prefetchedDaily[fav.id]!
            }
            else
            {
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                
                networkClient?.fetchWeatherForecast(for: coordinates, units: Globals.degreeScale.toString(), completion: { (currently, hourly, daily, error) in
                    if let error = error {
                        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Cannot create dequeue cell due to \(error.localizedDescription)...")
                        
                        return
                    }
                    
                    self.prefetched[fav.id] = currently!
                    self.prefetchedHourly[fav.id] = hourly!
                    self.prefetchedDaily[fav.id] = daily!
                    
                    cell.configure(with: currently, for: nil)
                    collectionView.reloadItems(at: [indexPath])
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
            rc = favourites?.count ?? 1
        }
        
        return rc
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == favouritesCollectionView else {
            return
        }
    
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        guard let fav = favourites?[currentIndex] else {
            fatalError("Cannot get fav...")
        }
        
        currentLocationTimeZoneId = fav.timeZoneId
        
        reloadDetails(for: fav)
        
        lastFavouriteIndex = currentIndex
        pageControl.currentPage = currentIndex
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        var currentPlacemark: CLPlacemark?
        
        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Trying to obtain current location...")
        
        geocoder.reverseGeocodeLocation(locations[0]) { (placemark, error) in
            if let error = error {
                let userInfo: [String: Any] = ["error": error]
                
                NotificationCenter.default.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: userInfo)
                
                return
            }
                
            currentPlacemark = placemark![0]
            let locality = currentPlacemark?.locality ?? "none"
            
            let initialLocation = Location()
            
            initialLocation.city = locality
            initialLocation.longitude = locations[0].coordinate.longitude
            initialLocation.latitude = locations[0].coordinate.latitude
            initialLocation.id = Int.min
            initialLocation.updateTimeZoneId {
                self.favourites?.delete(id: Int.min, commit: false)
                self.favourites?.insert(initialLocation, at: 0)
                self.favourites?.save()
                self.favouritesCollectionView.reloadData()
                self.pageControl.numberOfPages = self.favourites?.items.count ?? 0
                
                guard let fav = self.favourites?[self.scrollToFavourite] else {
                    fatalError("Error while getting fav...")
                }
                
                let coordinates = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
                self.networkClient?.fetchWeatherForecast(for: coordinates, units: Globals.degreeScale.toString(),completion: { (currently, hourly, daily, error) in
                    if let error = error {
                        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); \(error.localizedDescription)")
                        
                        return
                    }
                    
                    if self.reachability.connection != .unavailable {
                        self.dismissAlertController()
                    }
                    
                    self.prefetched[0] = currently!
                    self.prefetchedHourly[Int.min] = hourly!
                    self.prefetchedDaily[Int.min] = daily!
                    
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                    
                    Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Weather fetched for \(locality)...")
                })
                
                Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Placemark retrieved: \(locality)")
            }
        }
            
        self.hourlyCollectionView.reloadData()
        self.dailyTableView.reloadData()
        
        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Finished...")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Globals.log.debugMessage { "\(self.timeStamp); \(type(of: self)); \(#function); " + self.dateFormatter.string(from: Date()) + "; " + error.localizedDescription }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); \(status.rawValue)...")
         
        let favCount = favourites?.count ?? 0
        
        if (status == .denied || status == .restricted) && favCount < 1 {
            Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Location services not available, favs are empty. ")
            
            self.performSegue(withIdentifier: "showFavorites", sender: self)
        }
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView != favouritesCollectionView { return }
        
        let rows = indexPaths.compactMap { i in return i.row }
        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Prefetching rows \(rows)...")
        
        guard let favourites = favourites else {
            fatalError("Cannot get favourites...")
        }
        
        for i in rows {
            let fav = favourites[i]!
            let coordinate = CLLocationCoordinate2D(latitude: fav.latitude, longitude: fav.longitude)
        
            DispatchQueue.main.async {
                self.networkClient?.fetchWeatherForecast(for: coordinate, units: Globals.degreeScale.toString(), completion: { (currently, hourly, daily, error) in
                    if let error = error {
                        Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Cannot prefetch due to \(error.localizedDescription)...")
                        
                        return
                    }
                    
                    if self.reachability.connection != .unavailable {
                        self.dismissAlertController()
                    }
                    Globals.log.debugMessage("\(self.timeStamp); \(type(of: self)); \(#function); Prefetched weather for row \(i)...")
                    
                    self.prefetched[fav.id] = currently!
                    self.prefetchedHourly[fav.id] = hourly!
                    self.prefetchedDaily[fav.id] = daily!
                })
            }
        }
    }
}
