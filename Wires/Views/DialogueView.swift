//
//  DialogueView.swift
//  Wires
//
//  Created by Patrick Perini on 4/21/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

@objc protocol DialogueViewDelegate: NSObjectProtocol {
    // MARK: Line Cycle
    optional func dialogueView(dialogueView: DialogueView, didStartLines lines: [String])
    optional func dialogueView(dialogueView: DialogueView, didDisplayLine line: String)
    optional func dialogueView(dialogueView: DialogueView, didFinishLines lines: [String])
}

@IBDesignable public class DialogueView: UILabel {
    // MARK: Properties
    @IBInspectable var loopsDialogue: Bool = true
    @IBInspectable var animates: Bool = true
    @IBInspectable var animationDuration: NSTimeInterval = 0.50
    
    @IBOutlet var delegate: DialogueViewDelegate?
    
    private var lineIndex: Int = 0
    var lines: [String] = [] {
        didSet {
            self.text = lines.first
            self.lineIndex = 0
            
            self.delegate?.dialogueView?(self, didStartLines: self.lines)
        }
    }
    
    override public var text: String? {
        didSet {
            if self.text != nil {
                self.delegate?.dialogueView?(self, didDisplayLine: self.text!)
            }
        }
    }
    
    // MARK: Modifiers
    func setNextLine() {
        // Increment and clamp line index
        self.lineIndex++
        if self.lineIndex >= self.lines.count {
            self.delegate?.dialogueView?(self, didFinishLines: self.lines)
            self.lineIndex = self.loopsDialogue ? 0 : self.lines.count - 1
        }
        
        self.text = self.lines[self.lineIndex]
    }
    
    // MARK: Responders
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.animates {
            UIView.animateWithDuration(self.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.alpha = 0.0
            }, completion: { (completed: Bool) in
                self.setNextLine()
                UIView.animateWithDuration(self.animationDuration * 3.0, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.alpha = 1.0
                }, completion: nil)
            })
        } else {
            self.setNextLine()
        }
    }
}