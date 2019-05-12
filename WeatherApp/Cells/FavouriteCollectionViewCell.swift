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
    @IBOutlet weak var prefetchingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        print("\(type(of: self))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with currently: Currently?, for location: Location?) -> Void {
        var whilePrefetching = false
        
        if let currently = currently, let location = location {
            currentConditions.text = currently.summary
            currentCity.text = location.city
            currentTemp.text = String(currently.temperature) + "°"
        }
        else
        {
            whilePrefetching = true
        }
        
        currentConditions.isHidden = whilePrefetching
        currentCity.isHidden = whilePrefetching
        currentTemp.isHidden = whilePrefetching
        if !whilePrefetching {
            prefetchingIndicator.stopAnimating()
        }
        else
        {
            prefetchingIndicator.startAnimating()
        }
    }
}
