//
//  FirstController.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/18/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class FirstController: UIViewController {


    @IBAction func showTreeList(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "secondstoryboard")
 
    }
    @IBAction func Scan(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }



}
