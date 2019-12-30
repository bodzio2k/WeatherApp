//
//  HourlyCollectionViewFlowLayout.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 08/06/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

class HourlyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        scrollDirection = .horizontal
        
        let collectionViewSize = collectionView!.frame.size
        let width = collectionViewSize.width / 5.0
        let height = collectionViewSize.height
        
        itemSize = CGSize(width: width, height: height)
        
        minimumLineSpacing = 0.0
        sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
