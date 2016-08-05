//
//  Vector4D.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/// 4D vector type. Internally holds a `Vector`.
internal struct Vector4D: Interpolatable {
    
    // MARK: - Static properties
    
    /// Returns a zero-initialized `Vector4D` object.
    static var zero: Vector4D {
        return Vector4D(x: 0, y: 0, z: 0, w: 0)
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
    
    /// `y` component of the vector.
    var y: CGFloat {
        get {
            return data.values[1]
        }
        set {
            data.values[1] = newValue
        }
    }
    
    /// `z` component of the vector.
    var z: CGFloat {
        get {
            return data.values[2]
        }
        set {
            data.values[2] = newValue
        }
    }
    
    /// `w` component of the vector.
    var w: CGFloat {
        get {
            return data.values[3]
        }
        set {
            data.values[3] = newValue
        }
    }
    
    // MARK: - Init/deinit
    
    init(_ data: Vector) {
        var values = Array<CGFloat>(count: 4, repeatedValue: 0)
        
        for (index, value) in data.values.enumerate() {
            values[index] = value
        }
        
        self.data = Vector(values)
    }
    
    init(_ other: Vector4D) {
        self.init(other.data)
    }
    
    init(x: CGFloat, y: CGFloat, z: CGFloat, w: CGFloat) {
        self.init(Vector([x, y, z, w]))
    }
    
}

// MARK: - Protocol conformance

// MARK: Interpolatable

internal prefix func -(obj: Vector4D) -> Vector4D {
    return Vector4D(
        x: -obj.x,
        y: -obj.y,
        z: -obj.z,
        w: -obj.w
    )
}

internal func +(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x + rhs.x,
        y: lhs.y + rhs.y,
        z: lhs.z + rhs.z,
        w: lhs.w + rhs.w
    )
}

internal func -(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x - rhs.x,
        y: lhs.y - rhs.y,
        z: lhs.z - rhs.z,
        w: lhs.w - rhs.w
    )
}

internal func *(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x * rhs.x,
        y: lhs.y * rhs.y,
        z: lhs.z * rhs.z,
        w: lhs.w * rhs.w
    )
}

internal func *(multiplier: CGFloat, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: multiplier * rhs.x,
        y: multiplier * rhs.y,
        z: multiplier * rhs.z,
        w: multiplier * rhs.w
    )
}

internal func *(lhs: Vector4D, multiplier: CGFloat) -> Vector4D {
    return Vector4D(
        x: lhs.x * multiplier,
        y: lhs.y * multiplier,
        z: lhs.z * multiplier,
        w: lhs.w * multiplier
    )
}
