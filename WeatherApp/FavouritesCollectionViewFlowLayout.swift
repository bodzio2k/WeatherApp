//
//  FavouritesCollectionViewFlowLayout.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 08/06/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

class FavouritesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        scrollDirection = .horizontal
        
        let collectionViewSize = collectionView.frame.size
        let width = collectionViewSize.width
        let height = collectionViewSize.height
        
        itemSize = CGSize(width: width, height: height)
        
        minimumLineSpacing = 0.0
        sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = layoutAttributesForItem(at: itemIndexPath)
        attr?.alpha = 1.0
        return attr
    }
}
