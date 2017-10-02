//
//  History+CoreDataProperties.swift
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var searchText: String?
    @NSManaged public var date: NSDate?

}
