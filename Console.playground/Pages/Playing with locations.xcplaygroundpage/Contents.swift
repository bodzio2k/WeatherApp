//: [Previous](@previous)

import Foundation
import CoreLocation

let gc = CLGeocoder()
var pf: Locale?

var location = CLLocation(latitude: CLLocationDegrees(-26.242619999999999), longitude: CLLocationDegrees(-58.630389999999998))

gc.reverseGeocodeLocation(location, preferredLocale: pf, completionHandler: nil)

pf
