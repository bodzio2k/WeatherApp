//
//  Favourties.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 03/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CoreLocation

class Favourites: FavouritesProtocol {
    var items: [Location] = []
    var filePath = ""
    var locationManager: CLLocationManager!
    
    func delete(at index: Int, commit: Bool = false) -> Int {
        if index > items.count || index < 0 {
            return -1
        }
        
        items.remove(at: index)
        if commit == true {
            self.save()
        }
        
        return items.count
    }
    
    init(_ dir : String) {
        filePath = dir + "/favorites.json"
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        encoder.outputFormatting = .prettyPrinted
        
        let encoded = try? encoder.encode(items)
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forWritingAtPath: filePath) {
                file.truncateFile(atOffset: 0)
                file.write(encoded!)
                file.closeFile()
            }
        }
        else {
            FileManager.default.createFile(atPath: filePath, contents: encoded!, attributes: nil)
        }
        
        print("Saved at \(filePath)...")
    }
    
    func load() {
        let decoder = JSONDecoder()
        
        print("Attempting to load favourties from \(filePath)...")
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forReadingAtPath: filePath) {
                let data = file.readDataToEndOfFile()
                let favourites = try? decoder.decode([Location].self, from: data)
                self.items = favourites!
                file.closeFile()
            }
        }
        else
        {
            locationManager = CLLocationManager()
            //locationManager.delegate = self as? CLLocationManagerDelegate
            
            let initialLocation = Location()
            
            items.append(initialLocation)
            save()
        }
    }
    
    func add(_ newLocation: Location) {
        let alreadyInFavourties = items.contains(newLocation)
        
        if !alreadyInFavourties {
            items.append(newLocation)
        }
    }
}
