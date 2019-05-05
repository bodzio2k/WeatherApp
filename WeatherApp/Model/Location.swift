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
    var city: String = "unknown"
    var country: String = "unknown"
    var countryCode: String?
    var id: Int = Int.min
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    var name: String = "unknown"
    var region: String?
    var regionCode: String?
    var type: String?
    var wikiDataId: String?
    var timeZoneAbbr: String?

    override init() {
        super.init()
    }
    
    init(jsonData: [String:Any]) {
        super.init()
        
        self.city = jsonData["name"] as? String ?? "unknown"
        self.region = jsonData["region"] as? String
        self.country = jsonData["country"] as? String ?? "unknown"
        self.id = jsonData["id"] as? Int ?? Int.min
        self.longitude = jsonData["longitude"] as? Double ?? 0.00
        self.latitude = jsonData["latitude"] as? Double ?? 0.00
        
        updateTimezoneAbbr { return }
    }
    
    func updateTimezoneAbbr(_ completionHandler: @escaping () -> Void) {
        let gc = CLGeocoder()
        
        let location = CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        
        gc.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.timeZoneAbbr = placemark.timeZone?.abbreviation() ?? "UTC"
                
                completionHandler()
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
