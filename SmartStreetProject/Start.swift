//
//  Start.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 2/7/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class Start: UIViewController {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var start: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let textcolor = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        nameLable.textColor = textcolor
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
    }
    
    
    
}
