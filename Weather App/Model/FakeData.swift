//
//  FakeData.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CSV

class FakeData: NSObject {
    //MARK: Properties
    var locations: [Location] = []
    var favourites: [Location]?
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    var filePath: String!
    
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
        
        locations = getAll()
        filePath = documentDirectory + "/favorites.json"
        loadFavorites()
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
    
    //MARK: Model
    func saveFavorites() {
        let encoder = JSONEncoder()
        
        let encoded = try? encoder.encode(favourites)
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forWritingAtPath: filePath) {
                file.write(encoded!)
            }
        }
        else {
            FileManager.default.createFile(atPath: filePath, contents: encoded!, attributes: nil)
        }
        
        print("Saved at \(filePath)...")
    }
    
    func loadFavorites() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentDirectory + "/favorites.json"
        let decoder = JSONDecoder()
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forReadingAtPath: filePath) {
                let data = file.readDataToEndOfFile()
                let favourites = try? decoder.decode([Location].self, from: data)
                self.favourites = favourites
            }
            
        }
    }

}
