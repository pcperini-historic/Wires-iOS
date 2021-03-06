//
//  AppDelegate.swift
//  Wires
//
//  Created by Patrick Perini on 4/20/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

// MARK: Macros
let BETA: Bool = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Types
    enum NotificationType: String {
        case Headline = "com.pcperini.Wires.headline"
        case Default = "com.pcperini.Wires.default"
    }
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        if NSUserDefaults.standardUserDefaults().boolForKey("deviceTokenRequested") {
            self.registerForRemoteNotifications()
        }
        
        return true
    }
    
    // MARK: Device Token Handlers
    func registerForRemoteNotifications() {
        // Settings
        let userNotificationTypes: UIUserNotificationType = (UIUserNotificationType.Alert | UIUserNotificationType.Sound)
        
        let openAction = UIMutableUserNotificationAction()
        openAction.identifier = "openURL:"
        openAction.title = "Source"
        openAction.activationMode = UIUserNotificationActivationMode.Foreground
        openAction.authenticationRequired = false
        openAction.destructive = false
        
        let headlineCategory = UIMutableUserNotificationCategory()
        headlineCategory.identifier = NotificationType.Headline.rawValue
        headlineCategory.setActions([openAction], forContext: UIUserNotificationActionContext.Default)
        
        let userNotificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: Set([headlineCategory]))
        UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationSettings)
        
        // Notifications
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "deviceTokenRequested")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults(suiteName: "group.Wires")?.setBool(true, forKey: "deviceTokenRequested")
        NSUserDefaults(suiteName: "group.Wires")?.synchronize()
    }
    
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
            let device = Device(token: deviceToken)
            device.register()
            
            NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "deviceToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if let viewController = self.window?.rootViewController as? ViewController {
            viewController.deviceDidRegisterForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        switch userInfo["notificationType"] as! String {
        case NotificationType.Headline.rawValue:
            self.openHeadlineFromRemoteNotification(userInfo)
            
        default:
            break
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        switch identifier! {
        case "openURL:":
            self.openHeadlineFromRemoteNotification(userInfo)
            
        default:
            break
        }
        
        completionHandler()
    }
    
    func openHeadlineFromRemoteNotification(userInfo: [NSObject: AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            if let sourceURL = userInfo["sourceURL"] as? String {
                UIApplication.sharedApplication().openURL(NSURL(string: sourceURL)!)
            }
        }
    }
    
    // MARK: Watch Handlers
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let identifier = userInfo?["identifier"] as? String {
            switch identifier {
            case "openURL:":
                let headline = Headline(dictionary: NSDictionary(dictionary: userInfo ?? [:]))
                headline.readableText { (readableText: String?) in
                    reply(["text": readableText ?? NSNull()])
                    return
                }
                
            case "lastURL":
                Headline.lastHeadline { (lastHeadline: Headline?) in
                    lastHeadline?.readableText { (readableText: String?) in
                        reply(["text": readableText ?? NSNull()])
                        return
                    }
                }
                
            default:
                reply(["text": NSNull()])
                return
            }
        } else {
            reply(nil)
        }
    }
    
    // MARK: State Handlers
    func applicationDidBecomeActive(application: UIApplication) {
        // Update Watch info
        let sharedDefaults = NSUserDefaults(suiteName: "group.Wires")
        
        sharedDefaults?.setBool(UIApplication.sharedApplication().isRegisteredForRemoteNotifications(),
            forKey: "applicationIsRegisteredForRemoteNotifications")
        sharedDefaults?.setBool(NSUserDefaults.standardUserDefaults().boolForKey("deviceTokenRequested"),
            forKey: "deviceTokenRequested")
        
        sharedDefaults?.synchronize()
        
        // Load view
        self.window?.rootViewController?.viewDidAppear(false)
    }
}

