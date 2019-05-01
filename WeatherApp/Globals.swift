//
//  Common.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 16/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

public struct Globals {
    static let maxLocationsCount = 200
    static let maxHourlyCount = 11
    static let maxNextDaysCount = 7
    static let weatherConditions: WeatherConditions = ["cloudy", "hail", "heavy_rain", "partly_cloudy", "rain", "storm", "snow", "sunny", "windy"]
    
    static let geoDBCitiesUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities"
    static let geoDBCitiesApiKey = "c05671319cmsh32fbc39efc265bcp13a062jsn77e8c381d4ea"
    static let geoDBCitiesApiHost = "wft-geo-db.p.rapidapi.com"
}
