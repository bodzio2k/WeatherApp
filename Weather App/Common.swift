//
//  Common.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 16/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        get {
            //return self[startIndex.advancedBy(i)]
            //return self[self.startIndex.advancedBy(i)]
            return self[index(startIndex, offsetBy: i)];
        }
    }
}
