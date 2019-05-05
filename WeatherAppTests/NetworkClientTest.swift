//
//  GeoDBCitiesTest.swift
//  WeatherAppTests
//
//  Created by Krzysztof Podolak on 14/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class NetworkClientTest: XCTestCase {
    var client: NetworkClient?
    
    override func setUp() {
        super.setUp()
        
        client = NetworkClient()
    }

    override func tearDown() {
        super.tearDown()
        
        client = nil
    }

    func testGetCities() {
        let expectation = XCTestExpectation(description: "Get cities")
        
        client!.fetchCities(by: "les") { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let _ = response {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetWeatherForecast() {
        let expectation = XCTestExpectation(description: "Get cities")
        
        let latitude = CLLocationDegrees(exactly: 23.01)
        let longtitude = CLLocationDegrees(exactly: 52.99)
        let coordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
        
        client!.fetchWeatherForecast(for: coordinates) { (currently, hourly, daily, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let _ = currently {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
