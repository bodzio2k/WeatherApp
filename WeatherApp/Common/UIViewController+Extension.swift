//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 22/11/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func errorOccured(_ notification: NSNotification) {
        var message = "Unknown"
        
        guard notification.name.rawValue == Globals.errorOccured else
        {
            return
        }
        
        if let userInfo = notification.userInfo, let error = userInfo["error"] as? Error {
            message = error.localizedDescription
        }
        
        if !isAlertPresent() {
            let alert = UIAlertController(title: "An error occured", message: message, preferredStyle: .alert)
            
            self.show(alert, sender: self)
        }
    }
    
    func isAlertPresent() -> Bool {
        if let vc = self.presentedViewController {
            if vc.isKind(of: UIAlertController.self) {
                return true
            }
        }
        
        return false
    }
}
