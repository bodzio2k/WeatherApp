//
//  Location.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

struct Location: Codable, Hashable {
    var city: String?
    var country: String?
    var countryCode: String?
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var region: String?
    var regionCode: String?
    var type: String?
    var wikiDataId: String?
    
    init(jsonData: [String:Any]) {
        self.name = jsonData["name"] as? String ?? "unknown"
    }
    
    init() {
        return
    }
}
 
/*public class Location: NSObject, Codable {
    var name = "undefined"
    var country: String?
    var id: Int
    
    init(_ name: String, _ country: String?, _ id: Int?) {
        self.name = name
        self.country = country ?? "undefined"
        self.id = id ?? -1
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        let l = object as! Location
        let rc = self.id == l.id
        
        return rc
    }
}
*/
