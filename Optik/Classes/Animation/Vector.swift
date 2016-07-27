//
//  Vector.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Foundation

/// Vector type that holds a collection of `CGFloat` values.
internal struct Vector {
    
    // MARK: - Properties
    
    /// Values contained in the vector.
    var values: [CGFloat]
    
    /// Number of values.
    let count: Int
    
    // MARK: Init/deinit
    
    /**
     Initializes a `Vector` object using specified values.
     
     - parameter values: Values.
     
     - returns: Initialized `Vector` object.
     */
    init(_ values: [CGFloat]) {
        self.values = values
        count = values.count
    }
    
    /**
     Initializes a `Vector` object from another `Vector`.
     
     - parameter other: `Vector` object.
     
     - returns: Initialized `Vector` object.
     */
    init(_ other: Vector) {
        self.init(other.values)
    }
    
}
