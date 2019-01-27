//
//  Location.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

public class Location: NSObject, Codable {
    var name = "undefined"
    var country: String?
    
    init(_ name: String, _ country: String?) {
        self.name = name
        self.country = country ?? "undefined"
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        let l = object as! Location
        let rc = self.country == l.country && self.name == l.name
        
        return rc
    }
}
