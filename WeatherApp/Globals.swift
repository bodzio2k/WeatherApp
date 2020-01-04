//
//  Common.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 16/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit
import Willow
import SystemConfiguration

public struct Globals {
    static let maxLocationsCount = 200
    static let maxHourlyCount = 23
    static let maxNextDaysCount = 7
    static let weatherConditions: WeatherConditions = ["cloudy", "hail", "heavy_rain", "partly_cloudy", "rain", "storm", "snow", "sunny", "windy"]
    
    static let geoDBCitiesUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities"
    static let geoDBCitiesApiKey = "c05671319cmsh32fbc39efc265bcp13a062jsn77e8c381d4ea"
    static let geoDBCitiesApiHost = "wft-geo-db.p.rapidapi.com"
 
    static let darkSkyUrl = "https://api.darksky.net/forecast"
    static let darkSkySecretKey = "5cf22a2a8a7bdbb5d69820ed2522de52"
    
    static var degreeScale: DegreeScale = .celsius
    
    enum DegreeScale {
        case celsius
        case fahrenheit
        
        func toString() -> String {
            switch self {
            case .celsius:
                return "si"
            case .fahrenheit:
                return "us"
            }
        }
    }
    
    static var highlightedAttrs: [NSAttributedString.Key: Any] {
        if #available(iOS 13, *) {
            return [.foregroundColor: UIColor.label]
        }
        else
        {
            return [.foregroundColor: UIColor.black]
        }
    }
    
    static var normalAttrs: [NSAttributedString.Key: Any] {
        if #available(iOS 13, *) {
            return [.foregroundColor: UIColor.secondaryLabel]
         }
         else
         {
             return [.foregroundColor: UIColor.lightGray]
         }
    }
    
    static var lastRefreshTime: Date?
    static let minRefreshInterval = 3600.0 // 1h
    
    static var needToRefresh: Date {
        let since = lastRefreshTime ?? Date()
        let rc = Date(timeInterval: -1 * minRefreshInterval - 1, since: since)
        
        return rc
    }
    
    static var defaultTimeZoneId: String {
        return "Europe/London"
    }
    
    static let errorOccured = "ERROR_OCCURED"
    static let didEnterForeground = "DID_ENTER_FOREGROUND"
    static let didEnterBackground = "DID_ENTER_BACKGROUND"
    
    static var log = Logger(logLevels: .all, writers: [ConsoleWriter()])
    
    static let searchForMinCharacterCount = 2
}
