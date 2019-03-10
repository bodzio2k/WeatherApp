//
//  SwinjectStoryboard+Extension.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 06/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.storyboardInitCompleted(HomeViewController.self) { (r, c) in
            c.favourites = r.resolve(FavouritesProtocol.self)
        }
        defaultContainer.storyboardInitCompleted(FavouritesViewController.self) { (r, c) in
            c.favourites = r.resolve(FavouritesProtocol.self)
        }
        defaultContainer.storyboardInitCompleted(LocationsViewController.self) { (r, c) in
            c.locations = r.resolve(LocationsProtocol.self)
        }
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        defaultContainer.register(FavouritesProtocol.self, factory: {_ in return Favourites(documentDirectory)})
        defaultContainer.register(LocationsProtocol.self, factory: {_ in return Locations(100)})
    }
}
