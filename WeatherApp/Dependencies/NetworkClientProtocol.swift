//
//  NetworkClientProtocol.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 08/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol NetworkClientProtocol {
    func fetchCities(by prefix: String, completion: @escaping ([Location]?, Error?) -> Void)
    func fetchWeatherForecast(for coordinate: CLLocationCoordinate2D, completion: @escaping (Currently?, [Hourly]?, [Daily]?, Error?) -> Void)
}
