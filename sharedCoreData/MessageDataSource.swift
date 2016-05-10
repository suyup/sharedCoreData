//
//  MessageDataSource.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/5/16.
//  Copyright © 2016 x. All rights reserved.
//

import UIKit
import CoreData

class MessageDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    struct Constants {
        static let entityName = "Message"
        static let sortAttribute = "date"
        static let cellReuseId = "MessageCell"
    }
    
    let tableView: UITableView
    let frc: NSFetchedResultsController
    
    lazy var dateFormat: NSDateFormatter = {
        let dateFormat = NSDateFormatter()
        dateFormat.timeStyle = .ShortStyle
        dateFormat.dateStyle = .ShortStyle
        return dateFormat
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableView
        
        let fetchRequest = NSFetchRequest.init(entityName: Constants.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: Constants.sortAttribute, ascending: false)]
        self.frc = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: context,
                                                   sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        self.frc.delegate = self
        self.refresh()
    }
    
    func refresh() {
        do {
            try self.frc.performFetch()
        } catch {
            print(error as NSError)
        }
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let message = self.frc.objectAtIndexPath(indexPath) as? Message {
            cell.textLabel?.text = message.body
            cell.detailTextLabel?.text = self.dateFormat.stringFromDate(message.date!)
        }
    }
    
    // MARK: TableViewDataSource Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellReuseId, forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: NSFetchedResultController Delegates
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Move:
            self.tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}

