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
    var locations: Locations!
    var favourites: Favourites!
    let locationsMaxCount = 100
    let favouritesDir = "/Users/bodzio2k"
    
    override func setUp() {
        super.setUp()
        
        locations = Locations(locationsMaxCount)
        favourites = Favourites(favouritesDir)
    }
    
    override func tearDown() {
        super.tearDown()
        
        locations = nil
        favourites = nil
    }
    
    func testCreatingLocations() {
        let created: Int
        
        created = locations.items.count
        
        XCTAssertEqual(created, locationsMaxCount, "OK")
    }
    
    func testCreatingFavourites() {
        XCTAssertNotNil(favourites, "Favourties is not nil.")
        
        for l in locations.items {
            favourites!.add(l)
        }
        
        XCTAssertEqual(favourites!.items.count, locationsMaxCount)
        favourites.save()
    }
    
    func testLoadFavourites() {
        favourites.load()
        
        XCTAssertEqual(favourites!.items.count, locationsMaxCount)
    }
    
    func testLocations() {
        let distinctCountries = locations!.distinctCountries.count
        
        XCTAssertNotEqual(distinctCountries, 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
