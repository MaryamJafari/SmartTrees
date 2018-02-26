//
//  TreeComments+CoreDataProperties.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/21/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import CoreData


extension TreeComments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TreeComments> {
        return NSFetchRequest<TreeComments>(entityName: "TreeComments")
    }

    @NSManaged public var text: String?
    @NSManaged public var treeName: String?
    @NSManaged public var treeId: Int16
    @NSManaged public var created: NSDate?

}
