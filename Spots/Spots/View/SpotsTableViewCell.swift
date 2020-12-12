//
//  SpotsTableViewCell.swift
//  Spots
//
//  Created by Shannon Su on 12/12/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class SpotsTableViewCell: UITableViewCell {

    @IBOutlet var spotTitle: UILabel!
    @IBOutlet var spotSubtitle: UILabel!
    @IBOutlet var spotImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
