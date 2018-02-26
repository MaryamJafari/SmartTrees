//
//  TreeAnnotation.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/15/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import MapKit
public let trees = ["Oak","Pine", "Maple", "Willow", "Eucalyptus", "Cedrus", "Ash", "Linden","Apple"]
class TreeAnnotation :NSObject,MKAnnotation{
    var coordinate =  CLLocationCoordinate2D()
    var treeNumber : Int
    var treeName : String
    var title :String?
    
    init(coordinate :CLLocationCoordinate2D, treeNumber : Int){
        self.coordinate = coordinate
        self.treeName = trees[treeNumber-1].capitalized
        self.treeNumber = treeNumber
        self.title = self.treeName
    }
}
