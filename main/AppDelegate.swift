//
//  AppDelegate.swift
//  main
//
//  Created by Suyu Pan on 4/21/16.
//  Copyright © 2016 x. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    struct Constants {
        static let taskName = "backgroundFetch"
        static let batches: UInt = 100000
    }

    var window: UIWindow?
    let bgTask = BackgroundFetch.init(batches: Constants.batches)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let app = UIApplication.sharedApplication()
        var taskId: UIBackgroundTaskIdentifier = 0
        let expirHandler = {
            self.bgTask.cancell()
            app.endBackgroundTask(taskId)
        }
        taskId = app.beginBackgroundTaskWithName(Constants.taskName, expirationHandler: expirHandler)
        self.bgTask.performSelector(#selector(self.bgTask.start), withObject: nil, afterDelay: 5)
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

