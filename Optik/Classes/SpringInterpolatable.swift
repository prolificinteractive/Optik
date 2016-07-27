//
//  SpringInterpolatable.swift
//  Optik
//
//  Created by Htin Linn on 7/21/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Foundation

internal protocol SpringInterpolatable {
    
    associatedtype VelocityType
    
    var values: [CGFloat] { get }
    
}

extension CGRect: SpringInterpolatable {
    
    typealias VelocityType = (CGFloat, CGFloat, CGFloat, CGFloat)
    
    var values: [CGFloat] {
        return [origin.x, origin.y, size.width, size.height]
    }
    
}

// Generic with type comparison

internal enum AnimatableProperty {
    
    case Frame
    
}

import UIKit

extension UIView {
    
    func _setFrame(frame: CGRect) {
        self.frame = frame
    }
    
    func _getFrame() -> CGRect {
        return frame
    }
    
}
