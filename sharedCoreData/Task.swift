//
//  Task.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/9/16.
//  Copyright © 2016 x. All rights reserved.
//

import UIKit

enum Task: UInt {
    case Insert
    case Update
    case Delete
    
    func task(id: UInt, size: UInt) -> NSOperation {
        var output = " task: \(id), modify size: \(size)"
        let task = NSBlockOperation.init {
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