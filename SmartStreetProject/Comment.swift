//
//  Comment.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/20/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import CoreData

class Comment: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    var treeBarcode : String!
    var treeID : Int!
    
    @IBOutlet weak var table: UITableView!
    
    var FRC : NSFetchedResultsController<TreeComments>!
    
    
    @IBOutlet weak var titleT: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        let treeName = PardeTreesFromCSVFile().getTreeNameFromBarcode(barcode: treeBarcode)
        titleT.text = "\(treeName) Comments"
        attemedFetch()
        
        treeID  = PardeTreesFromCSVFile().getTreeIdFromBarcode(barcode: treeBarcode)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attemedFetch()
        self.table.reloadData()
    }
    @IBAction func AddNewComment(_ sender: Any) {
        performSegue(withIdentifier: "Add", sender: treeID)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let mySection = FRC.sections{
            return mySection.count
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mySections = FRC.sections{
            let mysection = mySections[section]
            let sectionInfo = mysection.numberOfObjects
            return sectionInfo
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCell(cell: cell as! ItemCellTableViewCell, indexpath: indexPath as NSIndexPath )
        return cell;
    }
    func configureCell(cell : ItemCellTableViewCell, indexpath : NSIndexPath){
        let item = FRC.object(at: indexpath as IndexPath )
        cell.configCell(treeComment: item)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let treeComment = FRC.object(at: indexPath)
        performSegue(withIdentifier: "Edit", sender: treeComment)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit"{
            
            if let destination = segue.destination as? CommentDetail{
                if let treeComment = sender as? TreeComments{
                    destination.editedcomment = treeComment
                }
            }
            
            
        }
        
        if segue.identifier == "Add"{
            
            if let destination = segue.destination as? CommentDetail{
                //  if let treeId = sender as? Int{
                destination.id = treeID
                //  }
            }
            
            
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let myindexpath = newIndexPath{
                table.insertRows(at: [myindexpath], with: .fade)
            }
            break
            
        case .delete:
            if let myindexpath = newIndexPath{
                table.deleteRows(at: [myindexpath], with: .fade)
            }
            break
            
        case .update:
            if let myindexpath = newIndexPath{
                let cell = table.cellForRow(at: myindexpath)as! ItemCellTableViewCell
                configureCell(cell: cell, indexpath: myindexpath as NSIndexPath )
            }
            break
            
        case .move:
            if let myindexpath = newIndexPath{
                table.deleteRows(at: [myindexpath], with: .fade)
                
            }
            if let myindexpath = newIndexPath{
                table.insertRows(at: [myindexpath], with: .fade)
            }
            break
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemedFetch(){
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let fetchRequest : NSFetchRequest<TreeComments> = TreeComments.fetchRequest()
            let dateSort = NSSortDescriptor(key: "created", ascending: false)
            let treeID = PardeTreesFromCSVFile().getTreeIdFromBarcode(barcode: treeBarcode)
            
            fetchRequest.predicate = NSPredicate(format: "treeId == %@", "\(treeID)")
            
            fetchRequest.sortDescriptors = [dateSort]
            
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            controller.delegate = self
            FRC = controller
            
            
            try controller.performFetch()
        }
        catch{
            let err = error as NSError
            print("\(err)")
        }
        
    }
    
    
    
    
}
