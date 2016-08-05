//
//  Vector1D.swift
//  Optik
//
//  Created by Htin Linn on 7/26/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/// 1D vector type. Internally holds a `Vector`.
internal struct Vector1D: Interpolatable {
    
    // MARK: - Static properties
    
    /// Returns a zero-initialized `Vector1D` object.
    static var zero: Vector1D {
        return Vector1D(x: 0)
    }
    
    // MARK: - Properties
    
    /// Data.
    var data: Vector
    
    /// `x` component of the vector.
    var x: CGFloat {
        get {
            return data.values[0]
        }
        set {
            data.values[0] = newValue
        }
    }
    
    // MARK: - Init/deinit
    
    init(_ data: Vector) {
        var values = Array<CGFloat>(count: 1, repeatedValue: 0)
        
        for (index, value) in data.values.enumerate() {
            values[index] = value
        }
        
        self.data = Vector(values)
    }
    
    init(_ other: Vector1D) {
        self.init(other.data)
    }
    
    init(x: CGFloat) {
        self.init(Vector([x]))
    }
    
}

// MARK: - Protocol conformance

// MARK: Interpolatable

internal prefix func -(obj: Vector1D) -> Vector1D {
    return Vector1D(x: -obj.x)
}

internal func +(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x + rhs.x)
}

internal func -(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x - rhs.x)
}

internal func *(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x * rhs.x)
}

internal func *(multiplier: CGFloat, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: multiplier * rhs.x)
}

internal func *(lhs: Vector1D, multiplier: CGFloat) -> Vector1D {
    return Vector1D(x: lhs.x * multiplier)
}

