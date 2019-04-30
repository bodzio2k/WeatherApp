//
//  Location.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, Codable {
    var city: String?
    var country: String?
    var countryCode: String?
    var id: String?
    var latitude: Double!
    var longitude: Double!
    var name: String?
    var region: String?
    var regionCode: String?
    var type: String?
    var wikiDataId: String?
    var timeZoneAbbr: String?

    override init() {
        super.init()
    }
    
    init(jsonData: [String:Any]) {
        self.city = jsonData["name"] as? String ?? "unknown"
        self.region = jsonData["region"] as? String ?? "unknown"
        self.country = jsonData["country"] as? String ?? "unknown"
        self.id = jsonData["id"] as? String ?? "unknown"
        self.longitude = jsonData["longitude"] as? Double ?? 0.00
        self.latitude = jsonData["latitude"] as? Double ?? 0.00
    }
    
    func updateTimezoneAbbr() {
        let gc = CLGeocoder()
        
        let location = CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        
        gc.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.timeZoneAbbr = placemark.timeZone?.abbreviation() ?? "UTC"
            }
        })
        
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
