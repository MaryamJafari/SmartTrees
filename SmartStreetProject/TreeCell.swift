//
//  TreeCell.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/12/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class TreeCell: UICollectionViewCell {
    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var treeName: UILabel!
    
    @IBOutlet weak var typeAndCity: UILabel!
    var tree : Tree!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(tree : Tree){
        self.tree = tree
        treeName.text = tree.name.capitalized
        treeImage.image = UIImage(named: "\(self.tree.treeId)")
        typeAndCity.text = tree.species + "/" + tree.area
    }
}
