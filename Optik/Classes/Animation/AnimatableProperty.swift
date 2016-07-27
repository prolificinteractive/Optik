//
//  AnimatableProperty.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 *  Defines an animatable property for the animation system.
 */
internal protocol AnimatableProperty {
    
    /// Underlying property type.
    associatedtype PropertyType: VectorRepresentable
    
    /// Threshold value to use in determining if an animation is considered complete.
    var threshold: CGFloat { get }
    
    /// Function for reading the animatable property from a view.
    var read: (UIView) -> [CGFloat] { get }
    
    /// Function for writing the animatable property to a view.
    var write: (UIView, [CGFloat]) -> () { get }
    
}

/**
 *  View frame animatable property.
 */
internal struct ViewFrame: AnimatableProperty {
    
    typealias PropertyType = CGRect
    
    let threshold: CGFloat = 0.1
    let read: (UIView) -> [CGFloat] = { $0.frame.values }
    let write: (UIView, [CGFloat]) -> () = { $0.frame = CGRect($1) }
    
}

/**
 *  View alpha animatable property.
 */
internal struct ViewAlpha: AnimatableProperty {
    
    typealias PropertyType = CGFloat
    
    let threshold: CGFloat = 0.01
    let read: (UIView) -> [CGFloat] = { $0.alpha.values }
    let write: (UIView, [CGFloat]) -> () = { $0.alpha = CGFloat($1) }
    
}
