//
//  FavouriteCollectionViewCell.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 03/02/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var currentConditions: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        print("\(type(of: self))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
