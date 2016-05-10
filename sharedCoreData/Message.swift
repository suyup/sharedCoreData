//
//  Message.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/5/16.
//  Copyright © 2016 x. All rights reserved.
//

import Foundation
import CoreData

@objc(Message)
class Message: NSManagedObject {
    
    struct Constants {
        static let message = "Message"
        static let empty = "Empty"
    }
    
    class func new(title: String?) -> Message? {
        let context = CoreDataStack.instance.managedObjectContext
        let message = NSEntityDescription.insertNewObjectForEntityForName(Constants.message, inManagedObjectContext: context) as? Message
        message?.body = title?.isEmpty == true ? Constants.empty : title
        message?.date = NSDate()
        return message
    }

}
