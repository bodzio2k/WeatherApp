//
//  Common.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 16/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func getFakeData() -> FakeData {
        var appDelegate: AppDelegate?
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        return appDelegate!.fakeData
    }
}
