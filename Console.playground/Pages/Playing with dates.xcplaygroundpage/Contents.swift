import UIKit

let dateFormatter = DateFormatter()

let currentDate = Date(timeInterval: -3600, since: Date())

let nextHours = Calendar.current.range(of: Calendar.Component.hour, in: Calendar.Component.day, for: currentDate)![..<12]

for i in 0..<12 {
    let k = Date(timeInterval: Double(i * 3600), since: currentDate)
    dateFormatter.timeStyle = .short
    let l = dateFormatter.string(from: k)
    print(k, ", ", l)
    
}

dateFormatter.weekdaySymbols

for i in 0..<7 {
    let nextDay = Calendar.current.date(byAdding: .day, value: i, to: currentDate)
    dateFormatter.dateFormat = "EE"
    let nd = dateFormatter.string(from: nextDay!)
    print(nd)
}

let date = Date(timeIntervalSince1970: 1558873083)
dateFormatter.timeStyle = .short
dateFormatter.dateFormat = ""
dateFormatter.string(from: date)
