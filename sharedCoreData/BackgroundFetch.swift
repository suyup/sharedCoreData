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
    
    private let fetchQueue: NSOperationQueue = {
        let fetchQueue = NSOperationQueue()
        fetchQueue.maxConcurrentOperationCount = 1
        fetchQueue.name = Constants.queue
        fetchQueue.suspended = true
        return fetchQueue
    }()

    init(batches: UInt) {
        self.batches = batches
        super.init()
        self.addOperations(self.batches)
    }
    
    private func addOperations(batches: UInt) {
        var operations = [NSOperation]()
        for index in 0...batches {
            operations.append(getRandomTask(index))
        }
        self.fetchQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    private func getRandomTask(index: UInt) -> NSOperation {
        let random = UInt(arc4random_uniform(10) + 1)
        return Task(rawValue: UInt(index % 3))!.task(index, size: random)
    }
    
    func start() {
        if self.fetchQueue.operationCount == 0 {
            self.addOperations(self.batches)
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





