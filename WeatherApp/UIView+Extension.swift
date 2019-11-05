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
        let borderWidth: CGFloat = 0.5
        let borderColor: CGColor!
        let bottomLineY: CGFloat!
        let size: CGSize = frame.size
        
        print("\(self); \(size)")
        
        if #available(iOS 13, *) {
            borderColor = UIColor.systemGray.cgColor
        }
        else
        {
            borderColor = UIColor.black.cgColor
        }
        
        bottomLineY = size.height - borderWidth
        
        print("bottomLineY is\(bottomLineY!)")
        
        topLine.borderColor = borderColor
        topLine.frame = CGRect(x: 0, y: 0, width: width, height: borderWidth)
        topLine.borderWidth = borderWidth
        
        bottomLine.borderColor = borderColor
        bottomLine.frame = CGRect(x: 0, y: bottomLineY, width: width, height: borderWidth)
        bottomLine.borderWidth = borderWidth
        
        self.layer.addSublayer(topLine)
        self.layer.addSublayer(bottomLine)
        
        self.layer.masksToBounds = true
        
    }
}
