//
//  circledView.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/21/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class circledView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: Constant().SHADOW_GRAY, green:Constant().SHADOW_GRAY, blue: Constant().SHADOW_GRAY, alpha: 0.9).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        
    }
    
}
