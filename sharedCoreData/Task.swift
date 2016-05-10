//
//  Task.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/9/16.
//  Copyright © 2016 x. All rights reserved.
//

import CoreData

enum Task: UInt {
    case Insert
    case Update
    case Delete
    
    func task(id: UInt, size: UInt) -> NSOperation {
        var output = " task: \(id), modify size: \(size)"
        let task = NSBlockOperation.init {
            var messages = [Message]()
            for index in 0..<size {
                if let message = Message.new(String(id * 10 + index)) {
                    messages.append(message)
                }
            }
            CoreDataStack.instance.saveContext()
            switch self {
            case .Insert: output = "Insert" + output
            case .Update: output = "Update" + output
            case .Delete: output = "Delete" + output
            }
            print(output)

        }
        return task
    }
}