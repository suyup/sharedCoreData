//
//  Message+CoreDataProperties.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/5/16.
//  Copyright © 2016 x. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var body: String?
    @NSManaged var date: NSDate?
    @NSManaged var destination: NSNumber?

}
