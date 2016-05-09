//
//  CoreDataStack.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 4/21/16.
//  Copyright © 2016 x. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    struct Constants {
        static let appGroupIdentifier = "group.splab.x.sharedcoredata"
        static let databaseName = "shared.sqlite"
    }
    
    lazy var url: NSURL? = {
        guard let appGroupShareDir = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(Constants.appGroupIdentifier) else {
            print("Error getting app group shared directory.")
            abort()
        }
        return appGroupShareDir.URLByAppendingPathComponent(Constants.databaseName)
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            let options: [NSObject: AnyObject] = [NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                                                  NSMigratePersistentStoresAutomaticallyOption: 1]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.url, options: options)
        } catch {
            print(error as NSError)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    func saveContext () {   // throws
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
