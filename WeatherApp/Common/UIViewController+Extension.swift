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
import SnapKit

extension UIViewController {
    @objc func errorOccured(_ notification: NSNotification) {
        var message = "Unknown error occured."
        let errorLabel: UILabel = {
            let label = UILabel()
            
            label.backgroundColor = .red
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            label.restorationIdentifier = Globals.errorOccured
        
            return label
        }()
        
        guard notification.name.rawValue == Globals.errorOccured else
        {
            return
        }
        
        if let userInfo = notification.userInfo, let error = userInfo["error"] as? NSError {
            message = error.localizedDescription
        }
        
        if  !isAlertPresent() {
            errorLabel.text = message
            view.addSubview(errorLabel)
            errorLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.height.equalTo(self.view.frame.height / 28.0)
            }
            
            view.bringSubviewToFront(errorLabel)
        }
    }
    
    func dismissAlertController() {
        guard isAlertPresent() else {
            return
        }
        
        let errorLabel: UIView?
        
        errorLabel = self.view.subviews.first { (subview) in
            return subview.restorationIdentifier == Globals.errorOccured
        }
        
        if let errorLabel = errorLabel {
            errorLabel.removeFromSuperview()
        }
    }
    
    func isAlertPresent() -> Bool {
        let isFound: Bool
        
        let found = self.view.subviews.filter { (subview) in
            return subview.restorationIdentifier == Globals.errorOccured
        }
        
        isFound = found.count > 0
        
        return isFound
    }
    
    fileprivate func fadeInDuration() -> Double {
        return 0.5
    }
    
    func fadeIn() {
       UIView.animate(withDuration: fadeInDuration(), animations: {
        self.view.alpha = 1.0
       })
    }
       
    func fadeOut() {
       UIView.animate(withDuration: fadeInDuration(), animations: {
        self.view.alpha = 0.0
       })
   }
    
    var timeStamp: String {
        let dateFormatter = DateFormatter()
        let now = Date()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        
        return dateFormatter.string(from: now)
    }
}
