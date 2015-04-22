//
//  ShapeView.swift
//  Wires
//
//  Created by Patrick Perini on 4/21/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

@IBDesignable public class ShapeView: UIView {
    // MARK: Types
    public enum Shape {
        case Circle
        case Square
        case Rectangle
    }
    
    // MARK: Properties
    @IBInspectable var shape: Shape = Shape.Circle
    
    var bezierPath: UIBezierPath {
        var squaredBounds: CGRect = self.bounds
        squaredBounds.size.width = min(self.bounds.width, self.bounds.height)
        squaredBounds.size.height = squaredBounds.width
        
        switch (shape) {
        case .Circle:
            return UIBezierPath(roundedRect: squaredBounds, cornerRadius: squaredBounds.width / 2.0)
            
        case .Square:
            return UIBezierPath(rect: squaredBounds)
            
        case .Rectangle:
            return UIBezierPath(rect: self.bounds)
        }
    }
    
    // MARK: Drawing Handlers
    override public func drawRect(rect: CGRect) {
        self.tintColor.setFill()
        self.bezierPath.fill()
    }
}
