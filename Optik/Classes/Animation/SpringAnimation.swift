//
//  SpringAnimation.swift
//  Optik
//
//  Created by Htin Linn on 7/18/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Animation that moves a given view to a new target using spring physics.
internal final class SpringAnimation<T: VectorRepresentable, U: AnimatableProperty where T == U.PropertyType> {
    
    // MARK: - Properties
    
    /// View to be animated.
    private(set) weak var view: UIView?
    
    /// Friction constant used when calculating animation frames.
    var friction: CGFloat {
        get {
            return springIntegrator.friction
        }
        set {
            springIntegrator.friction = newValue
        }
    }
    
    /// Spring constant used when calculating animation frames.
    var spring: CGFloat {
        get {
            return springIntegrator.spring
        }
        set {
            springIntegrator.spring = newValue
        }
    }
    
    /// Callback for each animation frame.
    var onTick: ((finished: Bool) -> ())?
    
    // MARK: - Private properties
    
    private var currentVector: Vector
    private var currentVelocity: Vector
    private let toVector: Vector
    private let threshold: CGFloat
    
    private var springIntegrator: SpringIntegrator<T.InterpolatableType>
    
    private let lens: Lens<UIView, [CGFloat]>
    
    // MARK: - Init/Deinit

    /**
     Initializes a spring animation with given parameters.
     
     - parameter view:     View to animate.
     - parameter target:   Destination for the view.
     - parameter velocity: Starting velocity of the view.
     - parameter property: Property to animate.
     
     - returns: An initialized spring animation object.
     */
    init(view: UIView, target: T, velocity: T, property: U) {
        self.view = view
        
        threshold = property.threshold
        lens = property.lens
        
        toVector = Vector(target.values)
        currentVelocity = Vector(velocity.values)
        currentVector = Vector(lens.get(view))
        
        springIntegrator = SpringIntegrator()
    }
    
    // MARK: - Private functions
    
    private func isAnimationComplete() -> Bool {
        let currentValues = currentVector.values
        let toValues = toVector.values
        
        guard currentValues.count == toValues.count else {
            return false
        }
        
        for (index, value) in currentValues.enumerate() {
            if abs(value - toValues[index]) > threshold {
                return false
            }
        }
        
        return true
    }
    
}

// MARK: - Protocol conformance

// MARK: Animation

extension SpringAnimation: Animation {
    
    func animationTick(timeElapsed: CFTimeInterval, inout finished: Bool) {
        guard let view = view else {
            finished = true
            return
        }
        
        let currentInterpolatableVector = T.InterpolatableType(currentVector)
        let currentInterpolatableVelocity = T.InterpolatableType(currentVelocity)
        let toInterpolatableVector = T.InterpolatableType(toVector)
        
        let result = springIntegrator.integrate(
            currentInterpolatableVector - toInterpolatableVector,
            velocity: currentInterpolatableVelocity,
            dt: timeElapsed
        )
        
        currentVector.values = (currentInterpolatableVector + result.dpdt * CGFloat(timeElapsed)).data.values
        currentVelocity.values = (currentInterpolatableVelocity + result.dvdt * CGFloat(timeElapsed)).data.values
        
        lens.set(currentVector.values, view)

        if isAnimationComplete() {
            lens.set(toVector.values, view)
            finished = true
            
            onTick?(finished: true)
        } else {
            onTick?(finished: false)
        }
    }
    
}
