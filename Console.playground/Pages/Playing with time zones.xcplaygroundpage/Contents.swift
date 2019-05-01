import Foundation

let tz = TimeZone(secondsFromGMT: 7200)
//let tz = TimeZone(
tz?.abbreviation()
tz?.identifier
let tzz = TimeZone(abbreviation: "PDT")

let currentTime = Date()
let dateFormatter = DateFormatter()

dateFormatter.timeZone = tzz
dateFormatter.timeStyle = .full
dateFormatter.string(from: currentTime)
