//
//  Daily.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 03/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

struct Daily {
    var time: Date
    var summary: String
    var icon: String
    var temperatureHigh: Int
    var temperatureLow: Int
    var image: UIImage!
    
    init(jsonData: [String: Any]) {
        let time = jsonData["time"] as? Int64 ?? 0
        self.time = Date(timeIntervalSince1970: TimeInterval(integerLiteral: time))
        self.icon = jsonData["icon"] as? String ?? "refresh"
        self.summary = jsonData["summary"] as? String ?? "unknown"
        self.temperatureHigh = Int(jsonData["temperatureHigh"] as? Double ?? -273)
        self.temperatureLow = Int(jsonData["temperatureLow"] as? Double ?? -273)
        
        self.image = UIImage(named: icon)
    }
}

//"time": 1556661600,
//"summary": "Mostly cloudy throughout the day.",
//"icon": "partly-cloudy-day",
//"sunriseTime": 1556680026,
//"sunsetTime": 1556733678,
//"moonPhase": 0.88,
//"precipIntensity": 0.0001,
//"precipIntensityMax": 0.0003,
//"precipIntensityMaxTime": 1556690400,
//"precipProbability": 0.04,
//"precipType": "rain",
//"temperatureHigh": 66.22,
//"temperatureHighTime": 1556719200,
//"temperatureLow": 49.3,
//"temperatureLowTime": 1556766000,
//"apparentTemperatureHigh": 66.22,
//"apparentTemperatureHighTime": 1556719200,
//"apparentTemperatureLow": 44.7,
//"apparentTemperatureLowTime": 1556766000,
//"dewPoint": 35.97,
//"humidity": 0.5,
//"pressure": 1007.14,
//"windSpeed": 6.94,
//"windGust": 18.51,
//"windGustTime": 1556744400,
//"windBearing": 312,
//"cloudCover": 0.44,
//"uvIndex": 3,
//"uvIndexTime": 1556701200,
//"visibility": 7.83,
//"ozone": 404.5,
//"temperatureMin": 43.16,
//"temperatureMinTime": 1556683200,
//"temperatureMax": 66.22,
//"temperatureMaxTime": 1556719200,
//"apparentTemperatureMin": 40.09,
//"apparentTemperatureMinTime": 1556683200,
//"apparentTemperatureMax": 66.22,
//"apparentTemperatureMaxTime": 1556719200
