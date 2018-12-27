//
//  FakeData.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CSV

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
        let mainBundle = Bundle.main
        
        let pathToCities = mainBundle.path(forResource: "world-cities", ofType: "csv")
        let stream = InputStream(fileAtPath: pathToCities!)
        let csv = try? CSVReader(stream: stream!)
        
        while let row = csv?.next() {
            l.append(Location(row[0], row[1]))
        }
 
        return Array(l.prefix(100))
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
