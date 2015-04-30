//
//  InterfaceController.swift
//  Wires WatchKit Extension
//
//  Created by Patrick Perini on 4/22/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    // MARK: Properties
    @IBOutlet var label: WKInterfaceLabel?
    
    // MARK: Mutators
    func updateText(userInfo: [NSObject: AnyObject]) {
        WKInterfaceController.openParentApplication(userInfo) { (userInfo: [NSObject : AnyObject]!, error: NSError!) in
            var text = userInfo["text"] as? String ?? "Sorry, the headline's source could not be opened."
            
            // Format, then set
            text = text.stringByReplacingOccurrencesOfString("\n", withString: "\n\n", options: nil, range: nil)
            self.label?.setText(text)
        }
    }
    
    // MARK: State Handlers
    override func awakeWithContext(context: AnyObject?) {
        var text = "Good \(NSDate().temporalGreeting())."
        
        if let sharedDefaults = NSUserDefaults(suiteName: "group.Wires") {
            if sharedDefaults.boolForKey("applicationIsRegisteredForRemoteNotifications") {
                text += "\nWires is listening for breaking news headlines."
            } else if sharedDefaults.boolForKey("deviceTokenRequested") {
                text += "\nWires is fetching the most recent headline..."
                self.updateText(["identifier": "lastURL"])
            } else {
                text += "\nPlease launch Wires on your iPhone to begin."
            }
        }
        
        self.label?.setText(text)
    }
    
    // MARK: Notification Handlers
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        switch identifier! {
        case "openURL:":
            var userInfo = remoteNotification
            userInfo["identifier"] = "openURL:"
            self.updateText(userInfo)
            
        default:
            break
        }
    }
}
