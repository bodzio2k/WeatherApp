//
//  UIView+Extension.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 16/09/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSeparatorLines(width: CGFloat) {
        let topLine = CALayer()
        let borderWidth: CGFloat = 1.0
        let borderColor: CGColor
        
        if #available(iOS 13, *) {
            borderColor = UIColor.separator.cgColor
        }
        else
        {
            borderColor = UIColor.black.cgColor
        }
        
        topLine.borderColor = borderColor
        topLine.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 0.0 + borderWidth)
        topLine.borderWidth = borderWidth
        
        self.layer.addSublayer(topLine)
        
        self.layer.masksToBounds = true
    }
}
