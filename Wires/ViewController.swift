//
//  ViewController.swift
//  Wires
//
//  Created by Patrick Perini on 4/20/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var dialogueView: DialogueView!
    @IBOutlet var pulseView: PulseView!
    
    @IBOutlet var circleLongPressRecognizers: [UILongPressGestureRecognizer]!
    private var recognizedCircleLongPresses: [UILongPressGestureRecognizer] = []

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dialogueView.delegate = self
        self.setDialogueLines()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.pulseView.animating = true
    }
        
    // MARK: Mutators
    func setDialogueLines() {
        if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
            self.dialogueView.lines = [
                "Good \(NSDate().temporalGreeting()).",
                "Wires is listening for\nbreaking news headlines."
            ]
            
            self.dialogueView.loopsDialogue = true
        } else {
            self.dialogueView.lines = [
                "Good \(NSDate().temporalGreeting()).",
                "Wires is a delivery platform\nfor breaking news headlines.",
                "All headlines are curated\nfrom verified Twitter accounts.",
                "To receive headlines, allow\nWires to send push notifications",
                "and Wires will begin\npushing headlines.",
                "Wires will also push headlines\nto your Apple Watch.",
                "Please allow Wires\nto send you notifications."
            ]
        }
    }
    
    // MARK: Responders
    func deviceDidRegisterForRemoteNotifications() {
        self.setDialogueLines()
    }
    
    func allCirclesWereLongPressed() {
    }
}

extension ViewController: DialogueViewDelegate {
    // MARK: Line Cycle
    func dialogueView(dialogueView: DialogueView, didStartLines lines: [String]) {
    }
    
    func dialogueView(dialogueView: DialogueView, didDisplayLine line: String) {
    }
    
    func dialogueView(dialogueView: DialogueView, didFinishLines lines: [String]) {
        let userNotificationTypes: UIUserNotificationType = (UIUserNotificationType.Alert | UIUserNotificationType.Sound)
        let userNotificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let g1 = gestureRecognizer as? UILongPressGestureRecognizer {
            if let g2 = otherGestureRecognizer as? UILongPressGestureRecognizer {
                println(contains(self.circleLongPressRecognizers, g1) && contains(self.circleLongPressRecognizers, g2))
                return contains(self.circleLongPressRecognizers, g1) && contains(self.circleLongPressRecognizers, g2)
            }
        }
        
        return false
    }
    
    @IBAction func gestureWasRecognized(gestureRecognizer: UIGestureRecognizer) {
        self.recognizedCircleLongPresses = self.circleLongPressRecognizers.filter {
            $0.state == UIGestureRecognizerState.Began || $0.state == UIGestureRecognizerState.Changed
        }
        
        if recognizedCircleLongPresses == self.circleLongPressRecognizers {
            self.allCirclesWereLongPressed()
        }
        
        if let view = gestureRecognizer.view {
            var scaleTransform = CGAffineTransformIdentity
            
            switch gestureRecognizer.state {
            case .Began:
                scaleTransform = CGAffineTransformMakeScale(0.66, 0.66)
                
            case .Cancelled, .Ended:
                scaleTransform = CGAffineTransformIdentity
                
            default:
                break
            }
            
            UIView.animateWithDuration(0.33) {
                view.transform = scaleTransform
            }
        }
    }
}

