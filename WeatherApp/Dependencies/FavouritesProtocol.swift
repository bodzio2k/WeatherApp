//
//  FavouritesProtocol
//  Weather App
//
//  Created by Krzysztof Podolak on 03/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation

protocol FavouritesProtocol {
    var items: [Location] { get }
    var filePath: String { get set }
    
    func save() -> Void
    func load() -> Void
    func add(_ newLocation: Location) -> Void
}
