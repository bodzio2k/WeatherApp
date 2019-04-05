//
//  HomeViewController
//  Weather App
//
//  Created by Krzysztof Podolak on 27/11/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Swinject

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var currentLocation: Location?
    var currentForecast: Forecast?
    var favourites: FavouritesProtocol?
    var favouritesCount: Int?
    var scrollToFavourite = 0
    var locations: LocationsProtocol?
    
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
        favouritesCount = favourites?.items.count ?? 0
        
        if favouritesCount == 0 {
            let initialLocation = locations?.getLocation(by: 1132495)
            favourites?.add(initialLocation!)
            favourites?.save()
        }
        
        favouritesCollectionView.reloadData()
        favouritesCollectionView.scrollToItem(at: IndexPath(item: scrollToFavourite, section: 0), at: .right, animated: true)
        
        currentLocation = favourites?.items[scrollToFavourite]
        currentForecast = Forecast(for: currentLocation!)
        
        hourlyCollectionView.reloadData()
        dailyTableView.reloadData()
        
        return
    }
    
    // MARK: TablewView
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

    //MARK: Navigation
    @IBAction func onShowFavorites() {
        self.performSegue(withIdentifier: "showFavorites", sender: self)
    }
    
    @IBAction func unwindBackToHome(segue: UIStoryboardSegue) {
        return
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
            
            let row = currentForecast?.today[indexPath.row]
            
            cell.icon.image = row?.currentConditions
            cell.now.text = row?.currentHour
            cell.temp.text = row?.currentTemp
            //cell.now.text = currentForecast?.today[indexPath.row]
            //cell.icon.image = image
            //let currentTemp = currentForecast?.currentTemp ?? -99
            //cell.temp.text = String(currentTemp)
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.1
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
            let fav: Location = favourites!.items[indexPath.row]
            
            cell.currentConditions.text = "foggy"
            cell.currentCity.text = fav.name
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
            rc = favourites?.items.count ?? 0
        }
        
        return rc
    }
    
    
}
