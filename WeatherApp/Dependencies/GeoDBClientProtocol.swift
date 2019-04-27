//
//  GeoDBClientProtocol.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 08/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire

typealias WebServiceResponse = ([Location]?, Error?) -> Void

protocol GeoDBClientProtocol {
    var urlString: String { get }
    
    func fetchCities(by prefix: String, completion: @escaping WebServiceResponse)
    /*func fetchNearestCity(latitude: Float32, longtitude: Float32, completion: @escaping WebServiceResponse)*/
}
