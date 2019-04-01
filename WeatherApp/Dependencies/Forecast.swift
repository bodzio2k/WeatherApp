//
//  Forecast.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 31/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

class Forecast: ForecastProtocol {
    private let dateFormatter = DateFormatter()
    
    var today: Hourly
    var nextDays: Daily
    var currentTemp: Int
    var currentConditions: UIImage
    
    init(for location: Location) {
        today = [:]
        nextDays = [:]
        let currentDate = Date()
        dateFormatter.timeStyle = .short
        
        for i in 0...Globals.maxHourlyCount {
            let nextHour = Date(timeInterval: Double(i * 3600), since: currentDate)
            let k = dateFormatter.string(from: nextHour)
            let v = Int.random(in: -20...20)
            self.today[k] = String(v)
        }
        
        for i in 0...Globals.maxNextDaysCount {
            self.nextDays[String(i)] = ""
        }
        
        nextDays = [:]
        currentTemp = -1
        currentConditions = UIImage(named: "rain")!
    }
}
