//
//  TableViewController.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/5/16.
//  Copyright © 2016 x. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    struct Constants {
        static let message = "Message"
        static let empty = "Empty"
        static let ok = "OK"
        static let delete = "Delete"
        static let edit = "Edit"
    }
    
    let coredataStack = CoreDataStack()
    
    lazy var dataSource: MessageDataSource = {
        return MessageDataSource.init(tableView: self.tableView, context: self.coredataStack.managedObjectContext)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }
    
    @IBAction func createMessage(_: UIBarButtonItem) {
         self.presentTextField { title in
            let message = NSEntityDescription.insertNewObjectForEntityForName(Constants.message, inManagedObjectContext: self.coredataStack.managedObjectContext) as? Message
            message?.body = title?.isEmpty == false ? title : Constants.empty
            message?.date = NSDate()
            self.coredataStack.saveContext()
        }
    }
    
    private func presentTextField(handler: ((String?) -> Void)?) {
        if self.presentingViewController == nil {
            let input = UIAlertController.init(title: Constants.message, message: nil, preferredStyle: .Alert)
            input.addTextFieldWithConfigurationHandler { textField in
                textField.placeholder = Constants.empty
            }
            let action = UIAlertAction.init(title: Constants.ok, style: .Default) { _ in
                if let handler = handler {
                    handler(input.textFields?.first?.text)
                }
            }
            input.addAction(action)
            self.presentViewController(input, animated: false, completion: nil)
        }
    }
    
    // Mark: UITableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .Destructive, title: Constants.delete, handler: { (_, indexpath) in
            if let message = self.dataSource.frc.objectAtIndexPath(indexPath) as? Message {
                message.managedObjectContext?.deleteObject(message)
                self.coredataStack.saveContext()
            }
        })
        let editAction = UITableViewRowAction.init(style: .Normal, title: Constants.edit) { (_, indexpath) in
            if let message = self.dataSource.frc.objectAtIndexPath(indexPath) as? Message {
                self.presentTextField { title in
                    message.body = title?.isEmpty == false ? title : Constants.empty
                    message.date = NSDate()
                    self.coredataStack.saveContext()
                    // Unless changing a managed object status, modifing its attributes will not trigger fetch controller delegate.
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                }
            }
        }
        editAction.backgroundColor = UIColor.orangeColor()
        return [editAction, deleteAction]
    }
    
}
