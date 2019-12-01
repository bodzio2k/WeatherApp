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
    enum SeparatorPosition {
        case top
        case bottom
        case both
    }
    
    var borderWidth: CGFloat {
        return 0.5
    }
    
    func addSeparator(at y: CGFloat, width: CGFloat? = nil) {
        let borderLine = CALayer()
        let borderColor: CGColor!
        
        if #available(iOS 13, *) {
            borderColor = UIColor.systemGray.cgColor
        }
        else
        {
            borderColor = UIColor.black.cgColor
        }
        
        borderLine.borderColor = borderColor
        borderLine.borderWidth = borderWidth
        borderLine.frame = CGRect(x: 0, y: y, width: width ?? frame.size.width, height: borderWidth)
        
        self.layer.addSublayer(borderLine)
    }
    
    func addSeparator(at position: SeparatorPosition, width: CGFloat? = nil) {
        let borderLineY: CGFloat!
        
        switch position {
        case .top:
            borderLineY = 0
        case .bottom:
            borderLineY = frame.size.height - borderWidth
        default:
            addSeparator(at: .bottom, width: width)
            addSeparator(at: .top, width: width)
            return
        }
        
        addSeparator(at: borderLineY, width: width)
    }
}
