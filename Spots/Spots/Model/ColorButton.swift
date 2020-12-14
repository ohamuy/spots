//
//  ColorButton.swift
//  Spots
//
//  Created by Oliver Hamuy on 12/13/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createButton()
    }
    
    func createButton() {
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.clear.cgColor
    }
}
