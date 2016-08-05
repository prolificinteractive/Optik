//
//  VectorRepresentable.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/**
 *  A type that can be converted to and from an array of `CGFloat` and used as a `Vector` type.
 */
internal protocol VectorRepresentable {
    
    associatedtype InterpolatableType: Interpolatable

    /**
     Initializes from an array of `CGFloat`.

     - parameter values: Array of values.
     
     - returns: Initialized object.
     */
    init(_ values: [CGFloat])
    
    /// Convert to an array of `CGFloat`.
    var values: [CGFloat] { get }
    
}

// MARK: - Extensions

// MARK: CGRect

extension CGRect: VectorRepresentable {
    
    typealias InterpolatableType = Vector4D
    
    init(_ values: [CGFloat]) {
        guard values.count == 4 else {
            fatalError("Invalid number of values.")
        }
        
        self.init(x: values[0], y: values[1], width: values[2], height: values[3])
    }
    
    var values: [CGFloat] {
        return [origin.x, origin.y, size.width, size.height]
    }
    
}

// MARK: CGFloat

extension CGFloat: VectorRepresentable {
    
    typealias InterpolatableType = Vector1D
    
    init(_ values: [CGFloat]) {
        guard values.count == 1 else {
            fatalError("Invalid number of values.")
        }
        
        self = values[0]
    }
    
    var values: [CGFloat] {
        return [self]
    }
    
}

