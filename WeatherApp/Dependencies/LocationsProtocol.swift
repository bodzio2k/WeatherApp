//
//  LocationsProtocol.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 06/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation

protocol LocationsProtocol {
    var items: [Location] { get }
    var distinctCountries: [String] { get }
    
    func getLocations(byCountry country: String) -> [Location]
    func getLocation(at index: IndexPath) -> Location
    func getLocation(by id: Int) -> Location
    func filter(by subString: String) -> Void
    func getCityCount(in country: Int) -> Int
}
