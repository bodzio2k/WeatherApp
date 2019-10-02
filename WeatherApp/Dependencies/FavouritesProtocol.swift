//
//  FavouritesProtocol
//  Weather App
//
//  Created by Krzysztof Podolak on 03/03/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol FavouritesProtocol {
    var items: [Location] { get }
    var filePath: String { get set }
    
    func save() -> Void
    func load() -> Void
    func add(_ newLocation: Location) -> Void
    func delete(at index: Int, commit: Bool) -> Void
    func delete(id: Int, commit: Bool) -> Void
    func insert(_ newLocation: Location, at index: Int) -> Void
    func dragItems(_: IndexPath) -> [UIDragItem]
}
