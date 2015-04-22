//
//  PulseView.swift
//  Wires
//
//  Created by Patrick Perini on 4/20/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

@IBDesignable public class PulseView: UIView {
    // MARK: Class Properties
    private class var waypoints: [CGPoint] {
        return [
            // Line in
            CGPointMake(0.00, 0.50),
            CGPointMake(0.25, 0.50),
            
            // First spike
            CGPointMake(0.28, 0.25),
            CGPointMake(0.31, 0.75),
            CGPointMake(0.34, 0.50),
            
            // Line to
            CGPointMake(0.55, 0.50),
            
            // Second spike
            CGPointMake(0.60, 0.05),
            CGPointMake(0.65, 0.95),
            CGPointMake(0.70, 0.50),
            
            // Line out
            CGPointMake(1.00, 0.50)
        ]
    }
    
    private class var drawAnimationKey: String {
        return "PulseView.drawAnimation"
    }
    
    // MARK: Properties
    @IBInspectable var hidesWhenStopped: Bool = true
    @IBInspectable var autoreverses: Bool = false {
        didSet {
            self.bezierPathLayer.animationForKey(PulseView.drawAnimationKey).autoreverses = self.autoreverses
        }
    }
    
    @IBInspectable var duration: NSTimeInterval = 3.0 {
        didSet {
            self.bezierPathLayer.animationForKey(PulseView.drawAnimationKey).duration = self.duration
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            self.bezierPathLayer.lineWidth = self.lineWidth
        }
    }
    
    @IBInspectable var animating: Bool = false {
        didSet {
            if animating {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
    
    private var bezierPathLayer: CAShapeLayer
    
    // MARK: Initializers
    required public init(coder aDecoder: NSCoder) {
        self.bezierPathLayer = CAShapeLayer()
        
        super.init(coder: aDecoder)
        
        self.bezierPathLayer.bounds = self.layer.bounds
        self.layer.addSublayer(self.bezierPathLayer)
        
        self.bezierPathLayer.path = self.bezierPath().CGPath
        self.bezierPathLayer.lineWidth = self.lineWidth
        self.bezierPathLayer.strokeColor = self.tintColor.CGColor
        self.bezierPathLayer.fillColor = UIColor.clearColor().CGColor
    }

    // MARK: Accessors
    private func localPoint(waypoint: CGPoint) -> CGPoint {
        return CGPoint(x: waypoint.x * self.bounds.width,
            y: waypoint.y * self.bounds.height)
    }
    
    private func bezierPath() -> UIBezierPath {
        var path: UIBezierPath = UIBezierPath()
        path.moveToPoint(self.localPoint(PulseView.waypoints[0]))
        
        for var waypointIndex = 1; waypointIndex < PulseView.waypoints.count; waypointIndex++ {
            path.addLineToPoint(self.localPoint(PulseView.waypoints[waypointIndex]))
        }
        
        return path
    }

    // MARK: Animators
    func startAnimating() {
        var drawAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = self.duration
        
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        drawAnimation.autoreverses = self.autoreverses
        
        var drawAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        drawAnimationGroup.animations = [drawAnimation]
        
        drawAnimationGroup.repeatCount = HUGE
        drawAnimationGroup.duration = self.duration + 0.50 // delay
        
        self.bezierPathLayer.addAnimation(drawAnimationGroup, forKey: PulseView.drawAnimationKey)
        if self.hidesWhenStopped {
            self.hidden = false
        }
    }
    
    func stopAnimating() {
        self.bezierPathLayer.removeAnimationForKey(PulseView.drawAnimationKey)
        if self.hidesWhenStopped {
            self.hidden = true
        }
    }
}