//
//  Currently.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 02/05/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

struct Currently {
    var summary: String
    var icon: String {
        willSet {
            image = UIImage(named: newValue)
        }
    }
    private var image: UIImage!
    var temperature: Double
    
    init(jsonData: [String:Any]) {
        self.summary = jsonData["summary"] as? String ?? "unknown"
        self.icon = jsonData["icon"] as? String ?? "minus"
        self.temperature = jsonData["temperature"] as? Double ?? -273.15
    }
}
