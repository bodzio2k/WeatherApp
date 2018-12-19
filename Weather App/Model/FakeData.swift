//
//  FakeData.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

class FakeData {
    var locations: [Location]
    var distinctCountries: [String] {
        var rc: [String] = []
        
        for l in locations {
            if !rc.contains(l.country!) {
                rc.append(l.country!)
            }
        }
        return rc
    }
    var filteredLocations: [Location]?
    
    init() {
        locations = []
        locations.append(Location("Warszawa", "Polska"))
        locations.append(Location("Gdańsk", "Polska"))
        locations.append(Location("Wrocław", "Polska"))
        locations.append(Location("Zielona Góra", "Polska"))
        
        locations.append(Location("Drezno", "Repuplika Federalna Niemiec"))
        locations.append(Location("Lipsk", "Repuplika Federalna Niemiec"))
        locations.append(Location("Rostok", "Repuplika Federalna Niemiec"))
        locations.append(Location("Chociebuż", "Repuplika Federalna Niemiec"))
        locations.append(Location("Berlin", "Repuplika Federalna Niemiec"))
        
        locations.append(Location("Warna", "Bułgaria"))
        locations.append(Location("Sofia", "Bułgaria"))
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
        var rc = 0
        
        filteredLocations = locations.filter({ (Location) -> Bool in
            var rc = false
            
            let found = Location.name.uppercased().range(of: subString.uppercased())
            rc = found?.isEmpty ?? true
            
            return rc
        })
        
        locations = filteredLocations!
        
        rc = filteredLocations?.count ?? 0
        
        return rc
    }
}
