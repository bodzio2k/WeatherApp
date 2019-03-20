//
//  Locations.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 06/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CSV

class Locations: LocationsProtocol {
    func getCityCount(in country: Int) -> Int {
        var rc = 0
        
        let lookFor = distinctCountries[country]
        
        for l in items {
            if l.country == lookFor {
                rc = rc + 1
            }
        }
        
        return rc
    }
    
    var items: Set<Location>
    var distinctCountries: [String] {
        var rc: [String] = []
        
        for l in items {
            if !rc.contains(l.country!) {
                rc.append(l.country!)
            }
        }
        
        return rc
    }
    
    init(_ count: Int) {
        var l: [Location] = []
        let mainBundle = Bundle.main
        
        let pathToCities = mainBundle.path(forResource: "world-cities", ofType: "csv")
        let stream = InputStream(fileAtPath: pathToCities!)
        let csv = try? CSVReader(stream: stream!)
        
        while let row = csv?.next() {
            l.append(Location(row[0], row[1], Int(row[3])))
        }
        
        items = Set(l.prefix(count))
    }
    
    func getLocations(byCountry country: String) -> [Location] {
        var rc: [Location] = []
        
        for loc in self.items {
            if loc.country!.uppercased() == country.uppercased() {
                rc.append(loc)
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
    
    func getLocation(by id: Int) -> Location {
        let rc = items.first(where: {(Location) -> Bool in
            return Location.id == id
        })
        
        return rc ?? Location("none", "none", -2)
    }
    
    func filter(by subString: String) -> Int {
        var filteredLocations: [Location]?
        
        if subString.count == 0 {
            let rc = Locations(Globals.maxLocationsCount)
            
            self.items = rc.items
        }
        else
        {
            filteredLocations = items.filter({ (Location) -> Bool in
                if Location.name.range(of: subString, options: NSString.CompareOptions.caseInsensitive) != nil {
                    return true
                }
                
                return false
            })
            
            self.items = Set(filteredLocations!)
        }
        
        return self.items.count
    }
}
