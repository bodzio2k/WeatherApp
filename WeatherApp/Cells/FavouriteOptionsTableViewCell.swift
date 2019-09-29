//
//  FavouriteOptionsTableViewCell.swift
//  WeatherApp
//
//  Created by Krzysztof Podolak on 20/06/2019.
//  Copyright © 2019 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FavouriteOptionsTableViewCell: UITableViewCell {
    @IBOutlet weak var degreeScaleIndicator: UILabel!
    @IBOutlet weak var plusButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
