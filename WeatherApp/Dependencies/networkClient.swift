//
//  networkClient.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 14/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Alamofire

class NetworkClient: NetworkClientProtocol {
    func fetchCities(by prefix: String, completion: @escaping ([Location]?, Error?) -> Void) {
        var httpHeaders: HTTPHeaders? = [:]
        var parameters: Parameters? = [:]
        
        httpHeaders!["X-RapidAPI-Host"] = Globals.geoDBCitiesApiHost
        httpHeaders!["X-RapidAPI-Key"] = Globals.geoDBCitiesApiKey
        
        parameters!["namePrefix"] = prefix
        
        Alamofire.request(Globals.geoDBCitiesUrl,
                          method: HTTPMethod.get,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: httpHeaders)
            .validate()
            .responseJSON { response in
                if let err = response.error {
                    print(err.localizedDescription)
                    completion(nil, err)
                }
                
                if var responseDict = response.result.value as? [String:Any] {
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
