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
        let bottomLine = CALayer()
        let borderWidth: CGFloat = 1
        
        topLine.borderColor = UIColor.black.cgColor
        topLine.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: width, height: self.frame.size.height)
        topLine.borderWidth = borderWidth
        
        bottomLine.borderColor = UIColor.black.cgColor
        bottomLine.frame = CGRect(x: 0, y: 0, width: width, height: borderWidth)
        bottomLine.borderWidth = borderWidth
        
        self.layer.addSublayer(topLine)
        self.layer.addSublayer(bottomLine)
        
        self.layer.masksToBounds = true
        
    }
}
