import Foundation

let queue1 = DispatchQueue(label: "label1", qos: .userInitiated)
let queue2 = DispatchQueue(label: "label2", qos: .userInitiated)
let count = 100

queue1.async {
    for i in 0...count {
        print(i, "🏀")
    }
}
queue2.async {
    for i in 0...count {
        print(i, "⚽️")
    }
}

for i in 1000...1000 + count {
    print(i, "🏐")
}
