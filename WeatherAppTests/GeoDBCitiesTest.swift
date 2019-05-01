//
//  GeoDBCitiesTest.swift
//  WeatherAppTests
//
//  Created by Krzysztof Podolak on 14/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import XCTest
@testable import WeatherApp

class GeoDBCitiesTest: XCTestCase {
    var client: networkClient?
    
    override func setUp() {
        super.setUp()
        
        client = networkClient()
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
            
            if let response = response, let _ = response["data"] {
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
