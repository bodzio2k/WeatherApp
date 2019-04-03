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
    static let maxHourlyCount = 12
    static let maxNextDaysCount = 7
    static let weatherConditions: WeatherConditions = ["cloudy", "hail", "heavy_rain", "partly_cloudy", "rain", "storm", "snow", "sunny", "windy"]
}
