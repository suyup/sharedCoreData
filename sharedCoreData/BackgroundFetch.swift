//
//  BackgroundFetch.swift
//  sharedCoreData
//
//  Created by Suyu Pan on 5/9/16.
//  Copyright © 2016 x. All rights reserved.
//

import Foundation

class BackgroundFetch: NSObject {
    
    struct Constants {
        static let queue = "BackgroundFetch"
    }
    
    private let batches: UInt
    private let size: UInt
    
    private let fetchQueue: NSOperationQueue = {
        let fetchQueue = NSOperationQueue()
        fetchQueue.maxConcurrentOperationCount = 1
        fetchQueue.name = Constants.queue
        fetchQueue.suspended = true
        return fetchQueue
    }()

    init(batches: UInt = 1, size: UInt = 1) {
        self.batches = batches
        self.size = size
        super.init()
        self.addOperations(self.batches, batchSize: self.size)
    }
    
    private func addOperations(batches: UInt = 1, batchSize: UInt = 1) {
        for index in 0..<batches {
            let random = UInt(arc4random_uniform(10) + 1)
            let task = Task(rawValue: UInt(random % 3))!.task(index, size: random)
            self.fetchQueue.addOperation(task)
        }
    }
    
    func start() {
        if self.fetchQueue.operationCount == 0 {
            self.addOperations(self.batches, batchSize: self.size)
        }
        self.fetchQueue.suspended = false
    }
    
    func suspend() {
        self.fetchQueue.suspended = true
    }
    
    func cancell() {
        self.suspend()
        self.fetchQueue.cancelAllOperations()
    }
}
