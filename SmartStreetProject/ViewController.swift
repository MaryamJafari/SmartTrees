//
//  ViewController.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/12/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate  {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var treeCollection: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var inSearchableMode = false
    var trees = [Tree]()
    var filteredTrees = [Tree]()
    var barcode : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        treeCollection.delegate = self
        treeCollection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        parsTreeCSV()
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(inSearchableMode){
            return filteredTrees.count
        }
        return trees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TreeCell {
            var tree : Tree!
            if (inSearchableMode) {
                tree = filteredTrees[indexPath.row]
            }
            else{
                
                tree =  trees[indexPath.row]
            }
            cell.configureCell(tree: tree)
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tree : Tree!
        tree = trees[indexPath.row]
        performSegue(withIdentifier: "FromListToAbout", sender: tree.barcode)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromListToAbout"{
            if let destination = segue.destination as? About{
                if let barcode = sender as? String!{
                    destination.treeBarcode = barcode
                }
            }
            
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: 177, height: 168)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text == nil || searchBar.text == ""){
            inSearchableMode = false
            treeCollection.reloadData()
            view.endEditing(true)
        }
        else{
            inSearchableMode = true
            let lower = searchBar.text!.capitalized
            filteredTrees = trees.filter({$0.name.range(of: lower) != nil})
            treeCollection.reloadData()
            
        }
    }
    
    
    
    func parsTreeCSV()  {
        let path = Bundle.main.path(forResource: "Trees", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                var treeId : Int = 0
                var name : String = ""
                var barcode : String = ""
                var species : String = ""
                var lat : Double = 0.0
                var lon : Double = 0.0
                var age : Int = 0
                var desc : String = ""
                var city : String = ""
                
                if let id = row["id"]{
                    treeId = Int(id)!
                    
                }
                
                if let treeName = row ["identifier"]{
                    name = treeName
                    
                }
                if let treeBarcode = row ["barcode"]{
                    barcode = treeBarcode
                    
                }
                if let treeSpecies = row["species"]{
                    species = treeSpecies
                    
                }
                
                if let treeLat = row["lat"]{
                    lat = Double(treeLat)!
                    
                }
                if let treeLon = row["lon"]{
                    lon = Double(treeLon)!
                    
                }
                if let treeAge = row["age"]{
                    age = Int(treeAge)!
                }
                if let treeDescription = row["description"]{
                    desc = treeDescription
                }
                if let cityName = row["city"]{
                    city = cityName
                }
                
                let tree = Tree(name: name, treeId: treeId, barcode: barcode, species: species, age: age, latitude: lat, longtitude: lon, cityName: city, desc: desc)
                trees.append(tree)
            }
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
}


