//
//  FakeData.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

class FakeData {
    var locations: [Location] = []
    var distinctCountries: [String] {
        var rc: [String] = []
        
        for l in locations {
            if !rc.contains(l.country!) {
                rc.append(l.country!)
            }
        }
        return rc
    }
    
    init() {
        locations = getAll()
    }
    
    func getAll() -> [Location] {
        var l: [Location] = []
        
        l.append(Location("Warszawa", "Polska"))
        l.append(Location("Gdańsk", "Polska"))
        l.append(Location("Wrocław", "Polska"))
        l.append(Location("Zielona Góra", "Polska"))
        
        l.append(Location("Drezno", "Repuplika Federalna Niemiec"))
        l.append(Location("Lipsk", "Repuplika Federalna Niemiec"))
        
        l.append(Location("Rostok", "Repuplika Federalna Niemiec"))
        l.append(Location("Chociebuż", "Repuplika Federalna Niemiec"))
        l.append(Location("Berlin", "Repuplika Federalna Niemiec"))
        
        l.append(Location("Warna", "Bułgaria"))
        l.append(Location("Sofia", "Bułgaria"))
        
        return l
    }
    
    func getLocations(byCountry country: String) -> [Location] {
        var rc: [Location] = []
        
        for loc in self.locations {
            if loc.country!.uppercased() == country.uppercased() {
                rc.append(loc)
            }
        }
        
        return rc
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
        var rc: Location?
        let lookForCountry = distinctCountries[index.section]
        let citiesInCountry = getLocations(byCountry: lookForCountry)
        
        rc  = citiesInCountry[index.row]
        
        return rc!
    }
    
    func filter(by subString: String) -> Int {
        var rc = locations.count
        var filteredLocations: [Location]?
        
        if subString.count == 0 {
            locations = getAll()
            
            return rc
        }
        
        filteredLocations = getAll().filter({ (Location) -> Bool in
            if Location.name.range(of: subString, options: NSString.CompareOptions.caseInsensitive) != nil {
                return true
            }
            
            return false
        })
        
        self.locations = filteredLocations!
        
        rc = filteredLocations?.count ?? 0
        
        return rc
    }
}
