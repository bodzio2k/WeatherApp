//
//  FakeData.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CSV

/*class FakeData: NSObject {
    //MARK: Properties
    var locations: [Location] = []
    
    let dateFormatter = DateFormatter()
    
    var distinctCountries: [String] {
        var rc: [String] = []
        
        for l in locations {
            if !rc.contains(l.country!) {
                rc.append(l.country!)
            }
        }
        
        return rc
    }
    
    override init() {
        super.init()
        
        //locations = getAll()
        
        loadFavorites()
    }
    
    func getLocations(byCountry country: String) -> [Location] {
        
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        var rc = 0
        let lookFor = distinctCountries[section]
        
        for l in locations {
            if l.country == lookFor {
                rc = rc + 1
            }
        }
        
        return rc
    }
    
    func getLocation(at index: IndexPath) -> Location {
        
    }
    
    func getLocation(byId: Int) -> Location {
        
    }
    
    func filter(by subString: String) -> Int {
        
    }
    
    //MARK: Model
    func saveFavorites() {
        
    }
    
    func loadFavorites() {
        
    }
    
    func addToFavourties(_ newLocation: Location) {
        
    }
    
    //MARK: Forecasts
    func getForecast(for location: Location) -> Forecast {
        var rc = Forecast()
        
        rc.currentTemp = Int.random(in: -10...10)
        rc.currentConditions = getRandomConditions()
        rc.location = location
        rc.nextDays = nil
        rc.today = {() -> Hourly? in
            var rc: Hourly = [:]
            
            for i in 0..<12 {
                let nextHour = Date(timeInterval: Double(i * 3600), since: Date())
                
                dateFormatter.timeStyle = .short
                let hourString = dateFormatter.string(from: nextHour)
                
                rc[hourString] = "foggy"
            }
            
            return rc
        }()
        
        return rc
    }
    
    fileprivate func getRandomConditions() -> UIImage {
        let literal: String = weatherConditions.randomElement()!
        let rc = UIImage(named: literal) ?? UIImage(named: "hail")
        
        return rc!
    }
}
*/
