//
//  Currently.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 02/05/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation

struct Currently {
    var summary: String?
    var icon: String? {
        didSet {
            return
        }
    }
    var temperature: Double?
}
