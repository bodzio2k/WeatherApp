//
//  GeoDBClient.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 14/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire

class GeoDBClient: GeoDBClientProtocol {
    var urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities"
    
    func fetchCities(by prefix: String, completion: @escaping WebServiceResponse) {
        var httpHeaders: HTTPHeaders? = [:]
        var parameters: Parameters? = [:]
        
        httpHeaders!["X-RapidAPI-Host"] = "wft-geo-db.p.rapidapi.com"
        httpHeaders!["X-RapidAPI-Key"] = "c05671319cmsh32fbc39efc265bcp13a062jsn77e8c381d4ea"
        
        parameters!["namePrefix"] = prefix
        
        Alamofire.request(urlString,
                          method: HTTPMethod.get,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: httpHeaders)
            .validate()
            .responseJSON { response in
                if let err = response.error {
                    print(err.localizedDescription)
                    completion(nil, err)
                } else if let jsonDict = response.result.value as? [String: Any] {
                    completion(jsonDict, nil)
                }
            }
            //.responseString { response in
            //    print(response)
            //}
        
    }
}
