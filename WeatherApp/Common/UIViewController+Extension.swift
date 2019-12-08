//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 22/11/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit
import Network

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
            
            let pathMonitor = NWPathMonitor()
            let monitorQueue = DispatchQueue(label: "NetworkMonitor")
            
            pathMonitor.start(queue: monitorQueue)
            pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        }
    }
    
    func pathUpdateHandler(path: NWPath) -> Void {
        if path.status == NWPath.Status.satisfied{
            DispatchQueue.main.async {
                self.dismissAlertController()
            }
        }
    }
    
    func dismissAlertController() {
        /*guard isAlertPresent() else {
            print("AlertController dismissed already...")
            
            return
        }*/
        
        if let vc = self.presentedViewController {
            vc.dismiss(animated: true, completion: nil)
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
