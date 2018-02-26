//
//  TreeComment+CoreDataProperties.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/20/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import CoreData


extension TreeComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TreeComment> {
        return NSFetchRequest<TreeComment>(entityName: "TreeComment")
    }

    @NSManaged public var text: String?

}
