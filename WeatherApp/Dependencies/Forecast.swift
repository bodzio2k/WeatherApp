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
    
    var today: [Hourly] = []
    var nextDays: Daily
    
    init(for location: Location) {
        nextDays = [:]
        let currentDate = Date()
        dateFormatter.timeStyle = .short
        
        for i in 0...Globals.maxHourlyCount {
            let nextHour = Date(timeInterval: Double(i * 3600), since: currentDate)
            let nextHourString = dateFormatter.string(from: nextHour)
            let temp = String(Int.random(in: -20...20))
            
            let element = Hourly(currentConditions: UIImage(named: "rain")!, currentTemp: temp, now: nextHourString)
            
            today.append(element)
        }
        
        for i in 0...Globals.maxNextDaysCount {
            self.nextDays[String(i)] = ""
        }
    }
}
