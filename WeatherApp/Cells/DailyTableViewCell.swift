//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 04/04/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var conditions: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
}
