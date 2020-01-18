//
//  LauchViewController.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 14/01/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import CoreGraphics

class LauchViewController: UIViewController {
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var powerdBy: UIImageView!
    let animationDuration = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.01, execute: { () in
            self.performSegue(withIdentifier: "showHome", sender: self)
        })
        
        UIView.animate(withDuration: animationDuration, animations: {() in
            let comboTransform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransform(scaleX: 5.0, y: 5.0))
            
            self.appTitle.transform = comboTransform
            self.appTitle.alpha = 0.0
            self.copyright.alpha = 0.0
            self.powerdBy.alpha = 0.0
        })
    }
}
