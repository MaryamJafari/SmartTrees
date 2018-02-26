//
//  CommentDetail.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/20/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import CoreData
class CommentDetail: UIViewController {
    
    @IBOutlet weak var commentfortree: UITextField!
    var treeComment = TreeComments(context : context)
    var editedcomment : TreeComments!
    var id : Int!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (editedcomment != nil){
            loadItems()
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        
        if let myDesc =  commentfortree.text{
            treeComment.text = myDesc
        }
        if let treeID =  id{
            treeComment.treeId = Int16(treeID)
        }
        
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    func loadItems(){
        
        if editedcomment != nil{
            commentfortree.text = editedcomment.text
            
        }
    }
    
    
}
