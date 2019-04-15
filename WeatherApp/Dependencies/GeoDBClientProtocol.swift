//
//  GeoDBClientProtocol.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 08/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire

typealias WebServiceResponse = ([String: Any]?, Error?) -> Void

protocol GeoDBClientProtocol {
    var urlString: String { get }
    
    func fetchCities(by prefix: String, completion: @escaping WebServiceResponse)
}
