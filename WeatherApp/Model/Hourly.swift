//
//  Hourly.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 03/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

struct Hourly {
    var time: Date
    var summary: String
    var icon: String
    var image: UIImage!
    var temperature: Int
    
    init(jsonData: [String:Any]) {
        let time = jsonData["time"] as? Int64 ?? 0
        self.time = Date(timeIntervalSince1970: TimeInterval(integerLiteral: time))
        self.summary = jsonData["summary"] as? String ?? "unknown"
        self.icon = jsonData["icon"] as? String ?? "refresh"
        self.temperature = Int(jsonData["temperature"] as? Double ?? -273)

        self.image = UIImage(named: self.icon)
    }
}
//{
//    "time": 1556704800,
//    "summary": "Mostly Cloudy",
//    "icon": "partly-cloudy-day",
//    "precipIntensity": 0,
//    "precipProbability": 0,
//    "temperature": 62.09,
//    "apparentTemperature": 62.09,
//    "dewPoint": 36.36,
//    "humidity": 0.38,
//    "pressure": 1007,
//    "windSpeed": 9.86,
//    "windGust": 12.01,
//    "windBearing": 329,
//    "cloudCover": 0.72,
//    "uvIndex": 3,
//    "visibility": 6.22,
//    "ozone": 418.74
//},
