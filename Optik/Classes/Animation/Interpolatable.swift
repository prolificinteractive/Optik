//
//  Interpolatable.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 *  Defines a collection of functions required for interpolating values.
 */
internal protocol Interpolatable {
    
    /**
     Initializes and returns an `Interpolatable` object from a `Vector`.
     
     - parameter data: `Vector` data.
     
     - returns: Initialized `Interpolatable` object.
     */
    init(_ data: Vector)
    
    /// Converts and returns the receiver into a `Vector`. 
    var data: Vector { get }
    
    /**
     Negates specfied object and returns the result.
     
     - parameter obj: Object to negate.
     
     - returns: Result of negation.
     */
    prefix func -(obj: Self) -> Self
    
    /**
     Adds given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Sum of given objects.
     */
    func +(lhs: Self, rhs: Self) -> Self
    
    /**
     Subtracts given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Difference between given objects.
     */
    func -(lhs: Self, rhs: Self) -> Self
    
    /**
     Multiplies given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Product of given objects.
     */
    func *(lhs: Self, rhs: Self) -> Self
    
    /**
     Multiplies a `CGFloat` to given object and returns the result.
     
     - parameter multiplier: Multiplier.
     - parameter rhs:        Object to multiply.
     
     - returns: Result of the product.
     */
    func *(multiplier: CGFloat, rhs: Self) -> Self
    
    /**
     Multiplies a `CGFloat` to given object and returns the result.
     
     - parameter lhs:        Object to multiply.
     - parameter multiplier: Multiplier.
     
     - returns: Result of the product.
     */
    func *(lhs: Self, multiplier: CGFloat) -> Self
    
}
