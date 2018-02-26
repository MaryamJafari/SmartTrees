//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Maryam Jafari on 9/20/17.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var text: String?

}
