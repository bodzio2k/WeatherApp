//
//  SwinjectStoryboard+Extension.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 06/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import SwinjectStoryboard
//import SwinjectAutoregistration

extension SwinjectStoryboard {
    @objc class func setup() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let favourites = Favourites(documentDirectory)
        
        defaultContainer.storyboardInitCompleted(HomeViewController.self) { (r, c) in
            c.favourites = r.resolve(FavouritesProtocol.self)
        }
        defaultContainer.storyboardInitCompleted(FavouritesViewController.self) { (r, c) in
            c.favourites = r.resolve(FavouritesProtocol.self)
        }
        defaultContainer.storyboardInitCompleted(LocationsViewController.self) { (r, c) in
            c.favourites = r.resolve(FavouritesProtocol.self)
            c.geoDBClient = r.resolve(GeoDBClientProtocol.self)
        }
        
        defaultContainer.register(FavouritesProtocol.self, factory: {_ in return favourites})
        defaultContainer.register(GeoDBClientProtocol.self, factory: {_ in return GeoDBClient()})
        
        /*defaultContainer.autoregister(FavouritesProtocol.self, name: "Favourites", initializer: Favourites.init)
        defaultContainer.autoregister(LocationsProtocol.self, name: "Locations", initializer: Locations.init)
        
        defaultContainer.storyboardInitCompleted(HomeViewController.self, name: "Favourites", initCompleted: { r, c in
            //c.favourites = r.resolve(FavouritesProtocol.self, argument: documentDirectory)
            c.favourites = r ~> FavouritesProtocol.self
        })
        
        defaultContainer.storyboardInitCompleted(FavouritesViewController.self, name: "Favourites", initCompleted: { r, c in
            //c.favourites = r.resolve(FavouritesProtocol.self, argument: documentDirectory)
            c.favourites = r ~> FavouritesProtocol.self
        })
        
        defaultContainer.storyboardInitCompleted(LocationsViewController.self, name: "Locations", initCompleted: { r, c in
            //c.locations = r.resolve(LocationsProtocol.self)
            c.locations = r ~> LocationsProtocol.self
        })
        
        defaultContainer.storyboardInitCompleted(LocationsViewController.self, name: "Favourites", initCompleted: { r, c in
            c.favourites = r ~> FavouritesProtocol.self
        })*/
    }

}
