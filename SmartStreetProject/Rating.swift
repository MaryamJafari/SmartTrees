//
//  Rating.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 10/26/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import StoreKit

class Rating: UIViewController {
    var treeBarcode : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reviewApp(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
}


