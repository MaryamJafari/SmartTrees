//
//  ItemCellTableViewCell.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/21/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class ItemCellTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var TreeId : UILabel!
    
    @IBOutlet weak var desc: UILabel!
    func configCell(treeComment : TreeComments){
        title.text = treeComment.treeName
        desc.text = treeComment.text
    }
}
