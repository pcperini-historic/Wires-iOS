//
//  AppDelegate.swift
//  Wires
//
//  Created by Patrick Perini on 4/20/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Types
    enum NotificationType: String {
        case Headline = "com.pcperini.Wires.headline"
    }
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Device Token Handlers
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Use http://api.shephertz.com/tutorial/Push-Notification-iOS/ for Push help
        
        let deviceToken = deviceToken.description
            .stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            .stringByReplacingOccurrencesOfString("<", withString: "", options: nil, range: nil)
            .stringByReplacingOccurrencesOfString(">", withString: "", options: nil, range: nil)
        
        var registerToken = false
        if let registeredToken = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken") {
            registerToken = registeredToken != deviceToken
        } else {
            registerToken = true
        }
        
        if registerToken {
            WiresAPI.registerDeviceToken(deviceToken)
            
            NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "deviceToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if let viewController = self.window?.rootViewController as? ViewController {
            viewController.deviceDidRegisterForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println(userInfo)
        switch userInfo["notificationType"] as! String {
        case NotificationType.Headline.rawValue:
            if let sourceURL = userInfo["sourceURL"] as? String {
                UIApplication.sharedApplication().openURL(NSURL(string: sourceURL)!)
            }
            
        default:
            break
        }
    }
    
    // MARK: State Handlers
    func applicationDidBecomeActive(application: UIApplication) {
        self.window?.rootViewController?.viewDidAppear(false)
    }
}

