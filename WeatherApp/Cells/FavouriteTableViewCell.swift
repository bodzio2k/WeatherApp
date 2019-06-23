//
//  FavoriteTableViewCell.swift
//  Weather App
//
//  Created by Krzysztof Podolak on 09/12/2018.
//  Copyright © 2018 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentLocationIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
