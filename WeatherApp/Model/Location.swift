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
