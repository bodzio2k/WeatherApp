//
//  LocationForecast.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 31/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

struct Forecast {
    var location: Location?
    var today: Hourly?
    var nextDays: Daily?
    var currentTemp: Int?
    var currentConditions: UIImage?
}
