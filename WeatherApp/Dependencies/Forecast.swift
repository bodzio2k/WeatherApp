//
//  Forecast.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 31/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

class Forecast {
    private let dateFormatter = DateFormatter()
    private let currentDate = Date()
    
    var today: [Hourly] = []
    var nextDays: [Daily] = []
    let iconCount = Globals.weatherConditions.count
    
    init(for location: Location) {
        //getHourly()
        //getDaily()
    }
    
    /*private func getHourly () -> Void {
        dateFormatter.timeStyle = .short
        
        for i in 0...Globals.maxHourlyCount {
            let nextHour = Date(timeInterval: Double(i * 3600), since: currentDate)
            let currentHour = Calendar.current.component(.hour, from: nextHour)
            let temp = String(Int.random(in: -20...20))
            let iconName = Globals.weatherConditions[Int.random(in: 0...iconCount - 1)]
            let element = Hourly(currentConditions: UIImage(named: iconName)!, currentTemp: temp, currentHour: String(currentHour))
            
            today.append(element)
        }
    }*/
    
    /*private func getDaily () -> Void {
        for i in 0...Globals.maxNextDaysCount {
            let nextDay = Calendar.current.date(byAdding: .day, value: i, to: currentDate)
            dateFormatter.dateFormat = "EE"
            let dayOfWeek = dateFormatter.string(from: nextDay!)
            let minTemp = Int.random(in: -100...100)
            let maxTemp = Int.random(in: minTemp...minTemp + 10)
            let iconName = Globals.weatherConditions[Int.random(in: 0...iconCount - 1)]
            let element = Daily(dayOfWeek: dayOfWeek, minTemp: String(minTemp), maxTemp: String(maxTemp), conditions: UIImage(named: iconName)!)
            
            nextDays.append(element)
        }
    }*/
}
