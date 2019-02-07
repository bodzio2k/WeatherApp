//
//  HomeViewController
//  Weather App
//
//  Created by Krzysztof Podolak on 27/11/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var currentLocation: Location? {
        didSet(newValue) {
            print("didSet")
        }
    }
    
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
    }
    
    // MARK: TablewView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath)
        
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
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
            //let item  = items[indexPath.item]
            
            cell.now.text = "Now"//item.title
            cell.icon.image = UIImage(named: "cloudy")
            cell.temp.text = "21" + "°"
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.1
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
            
            cell.currentConditions.text = "LOL"
            cell.currentCity.text = "ROFL"
            cell.currentTemp.text = "22°"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var rc = 0
        
        if collectionView == hourlyCollectionView {
            rc = 12
        }
        
        if collectionView == favouritesCollectionView {
            rc = getFakeData().favourites?.count ?? 0
        }
        
        return rc
    }
}
