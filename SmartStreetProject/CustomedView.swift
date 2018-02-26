//
//  CustomedView.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/12/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class CustomedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: Constant().SHADOW_GRAY, green: Constant().SHADOW_GRAY, blue:Constant().SHADOW_GRAY, alpha: 0.9).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    
}
