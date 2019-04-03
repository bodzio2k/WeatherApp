//
//  LocationForecast.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 31/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

protocol ForecastProtocol {
    var today: [Hourly]  { get }
    var nextDays: Daily  { get }
}
