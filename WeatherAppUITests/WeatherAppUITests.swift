//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Krzysztof Podolak on 21/06/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let app = XCUIApplication()
        app.buttons["Favorites"].tap()
        app.tables/*@START_MENU_TOKEN@*/.images["icons8-plus"]/*[[".cells.images[\"icons8-plus\"]",".images[\"icons8-plus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.searchFields["SEARCH"].tap()
       
    }

}
