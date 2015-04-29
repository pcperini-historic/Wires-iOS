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
        self.label?.setText("Loading...")
        self.updateText(["identifier": "lastURL"])
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
