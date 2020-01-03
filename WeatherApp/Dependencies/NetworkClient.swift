//
//  networkClient.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 14/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class NetworkClient: NetworkClientProtocol {
    let nc = NotificationCenter.default
    var userInfo: [AnyHashable: Any] = ["error": ""]
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 4.0
        configuration.timeoutIntervalForResource = 4.0
        
        let sessionManager = SessionManager(configuration: configuration)
        
        return sessionManager
    }()
    var timeStamp: String {
        let dateFormatter = DateFormatter()
        let now = Date()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        
        return dateFormatter.string(from: now)
    }
    
    func fetchWeatherForecast(for coordinate: CLLocationCoordinate2D, units: String, completion: @escaping (Currently?, [Hourly]?, [Daily]?, Error?) -> Void) {
        let units = Globals.degreeScale == .celsius ? "si" : "us"
        let urlString = "\(Globals.darkSkyUrl)/\(Globals.darkSkySecretKey)/\(String(coordinate.latitude)),\(String(coordinate.longitude))?units=\(units)"
        var currently: Currently?
        var hourly: [Hourly]?
        var daily: [Daily]?
        
        sessionManager.request(urlString)
            .validate()
            .responseJSON { response in
                if let error = response.result.error {
                    self.userInfo["error"] = error
                    self.nc.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: self.userInfo)
                    
                    completion(nil, nil, nil, error)
                    
                    return
                }
                
                guard let responseDict = response.result.value as? [String:Any] else {
                    self.userInfo["error"] = NSError(domain: "", code: -9999)
                    self.nc.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: self.userInfo)
                    
                    return
                }
                
                if let currentlyDict = responseDict["currently"] as? [String:Any],
                    let hourlyDict = responseDict["hourly"] as? [String:Any],
                    let hourlyDataArray = hourlyDict["data"] as? [[String:Any]],
                    let dailyDict = responseDict["daily"] as? [String:Any],
                    let dailyDataArray = dailyDict["data"] as? [[String:Any]]
                {
                    currently = Currently(jsonData: currentlyDict)
                    hourly = hourlyDataArray.prefix(Globals.maxHourlyCount).compactMap { each in
                        let h = Hourly(jsonData: each)
                        return h
                    }
                    daily = dailyDataArray.prefix(Globals.maxNextDaysCount).compactMap { each in
                        let d = Daily(jsonData: each)
                        return d
                    }
                    
                    completion(currently, hourly, daily, nil)
                }
                else
                {
                    self.userInfo["error"] = NSError(domain: "", code: -9998)
                    self.nc.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: self.userInfo)
                }
            }
        }
    
    func fetchCities(by prefix: String, completion: @escaping ([Location]?, Error?) -> Void) {
        var httpHeaders: HTTPHeaders? = [:]
        var parameters: Parameters? = [:]
        
        httpHeaders!["X-RapidAPI-Host"] = Globals.geoDBCitiesApiHost
        httpHeaders!["X-RapidAPI-Key"] = Globals.geoDBCitiesApiKey
        
        parameters!["namePrefix"] = prefix
        
        sessionManager.request(Globals.geoDBCitiesUrl,
                          method: HTTPMethod.get,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: httpHeaders)
            .validate()
            .responseJSON { response in
                if let error = response.error {
                    self.userInfo["error"] = error
                    
                    self.userInfo["error"] = NSError(domain: "", code: -9996)
                    self.nc.post(name: Notification.Name(Globals.errorOccured), object: nil, userInfo: self.userInfo)
                    
                    return
                }
                
                if let responseDict = response.result.value as? [String:Any] {
                    let dataArray = responseDict["data"] as? [[String:Any]]
                    
                    let locations = dataArray.flatMap { locations -> [Location] in
                        var rc: [Location] = []
                        
                        for l in locations {
                            rc.append(Location(jsonData: l))
                        }
                        
                        return rc
                    }
                
                    completion(locations, nil)
                }
            }
    }
}
