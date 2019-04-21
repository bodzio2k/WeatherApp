//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Krzysztof Podolak on 10/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    var favourites: Favourites!
    let favouritesDir = "/Users/bodzio2k"
    
    override func setUp() {
        super.setUp()
        
        favourites = Favourites(favouritesDir)
    }
    
    override func tearDown() {
        super.tearDown()
        
        favourites = nil
    }
    
    /*func testCreatingLocations() {
        let created: Int
        
        created = locations.items.count
        
        XCTAssertEqual(created, Globals.maxLocationsCount, "OK")
    }*/
    
    /*func testCreatingFavourites() {
        XCTAssertNotNil(favourites, "Favourties is not nil.")
        
        for l in locations.items {
            favourites!.add(l)
        }
        
        XCTAssertEqual(favourites!.items.count, Globals.maxLocationsCount)
        favourites.save()
    }*/
    
    func testLoadFavourites() {
        favourites.load()
        
        XCTAssertEqual(favourites!.items.count, Globals.maxLocationsCount)
    }
    
    /*func testLocations() {
        let distinctCountries = locations!.distinctCountries.count
        let i = 0
        var citiesInCountryCount = 0
        
        XCTAssertNotEqual(distinctCountries, 0)
        
        for _ in locations!.distinctCountries {
            citiesInCountryCount = locations!.getCityCount(in: i)
            XCTAssertNotEqual(citiesInCountryCount, 0)
        }
    }*/
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /*func testFilteringLocations() {
        var phrases: [String: Int] = [:]
        
        phrases["les"] = 9
        phrases["dibba"] = 2
        phrases[""] = Globals.maxLocationsCount
        
        for (k, v) in phrases {
            let filteredCount = locations!.filter(by: k)
            XCTAssertEqual(filteredCount, v)
        }
        
    }*/
    
    func testDeletingFavourites() {
        var itemsCount: Int!
        var afterDeletion: Int!
        
        favourites.load()
        itemsCount = favourites.items.count
        
        afterDeletion = favourites.delete(at: -1)
        XCTAssertEqual(afterDeletion, -1)
        
        afterDeletion = favourites.delete(at: Int.max)
        XCTAssertEqual(afterDeletion, -1)
        
        afterDeletion = favourites.delete(at: 1)
        XCTAssertEqual(afterDeletion, itemsCount - 1)
        
    }
}
