//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 28/07/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation

extension Date {
    func getCurrentTimeString(in timeZoneId: String?) -> String {
        return getTimeString(from: self, in: timeZoneId)
    }
    
    func getTimeString(from: Date, in timeZoneId: String?) -> String {
        let dateFormatter = DateFormatter()
        
        let timeZoneIdUnescaped = (timeZoneId ?? "GMT").replacingOccurrences(of: "\\", with: "")
        let timeZone = TimeZone(identifier: timeZoneIdUnescaped)
        
        dateFormatter.timeZone = timeZone
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: from)
    }
    
    func getFullHourString(from time: Date, in timeZoneId: String?) -> String {
        return String(getTimeString(from: time, in: timeZoneId).prefix(2))
    }
}
