//
//  About.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/13/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class About: UIViewController {
    
    var tree : Tree!
    var treeBarcode : String!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var barcode: CustomedLable!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var treeDescription: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let treeWithBarcode = PardeTreesFromCSVFile().getTreeInfoFromBarcode(barcode: treeBarcode)
        updateUI(treeWithBarcode: treeWithBarcode)
    }
    
    func updateUI(treeWithBarcode: Tree){
        age.text = "\(treeWithBarcode.age)"
        treeDescription.text = treeWithBarcode.treeDescription
        cityName.text! = treeWithBarcode.area
        type.text! = treeWithBarcode.species
        name.text! = treeWithBarcode.name
        image.image = UIImage(named: "\(treeWithBarcode.treeId)")
    }
    
    
    func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AboutBack", sender: "")
    }
    
}
