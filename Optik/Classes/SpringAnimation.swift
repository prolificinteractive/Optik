//
//  SpringAnimation.swift
//  Optik
//
//  Created by Htin Linn on 7/18/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Animation that moves a given view to a new target using spring physics.
internal final class SpringAnimation<T: SpringInterpolatable> {
    
    // MARK: - Properties
    
    /// View to be animated.
    private(set) weak var view: UIView?
    
    /// Destination for the view.
    let target: T
    
    /// Friction constant used when calculating animation frames.
    var friction: CGFloat = 36.5
    
    /// Spring constant used when calculating animation frames.
    var spring: CGFloat = 500
    
    /// Callback for each animation frame.
    var onTick: (() -> ())?
    
    /// Current velocity of the animation.
    private(set) var velocity: T.VelocityType
    
    var setter: (T) -> ()
    
    var getter: () -> (T)
    
    // MARK: - Init/Deinit
    
    /**
     Initializes a spring animation with given parameters.
     
     - parameter view:          View to be animated.
     - parameter target:        Destination point for the view.
     - parameter velocity:      Starting velocity of the animation.
     
     - returns: An initialized spring animation object.
     */
    init(view: UIView, target: T, velocity: T.VelocityType, setter: (T) -> (), getter: () -> (T)) {
        self.view = view
        self.target = target
        self.velocity = velocity
        self.setter = setter
        self.getter = getter
    }
    
    // MARK: - Private functions
    
    // Source: http://gafferongames.com/game-physics/integration-basics/
    private func integrate(position: CGFloat, velocity: CGFloat, inout dxdt: CGFloat, inout dvdt: CGFloat, dt: CFTimeInterval) {
        let aPosition = velocity
        let aVelocity = accelerationForPosition(position, velocity: velocity)
        
        let bPosition = velocity + CGFloat(dt) * 0.5 * aVelocity
        let bVelocity = accelerationForPosition(position + CGFloat(dt) * 0.5 * aPosition, velocity: velocity + CGFloat(dt) * 0.5 * aVelocity)
        
        let cPosition = velocity + CGFloat(dt) * 0.5 * bVelocity
        let cVelocity = accelerationForPosition(position + CGFloat(dt) * 0.5 * bPosition, velocity: velocity + CGFloat(dt) * 0.5 * bVelocity)
        
        let dPosition = velocity + CGFloat(dt) * cVelocity
        let dVelocity = accelerationForPosition(position + CGFloat(dt) * cPosition, velocity: velocity + CGFloat(dt) * cVelocity)
        
        dxdt = 1.0 / 6.0 * (aPosition + 2.0 * (bPosition + cPosition) + dPosition)
        dvdt = 1.0 / 6.0 * (aVelocity + 2.0 * (bVelocity + cVelocity) + dVelocity)
    }
    
    private func accelerationForPosition(position: CGFloat, velocity: CGFloat) -> CGFloat {
        return -spring * position - friction * velocity
    }
    
    private func integrate(frame: CGRect, target: T, velocity: T.VelocityType, timeElapsed: CFTimeInterval) -> (frame: T, velocity: T.VelocityType) {
        var dp1: CGFloat = 0
        var dp2: CGFloat = 0
        var dp3: CGFloat = 0
        var dp4: CGFloat = 0
        var dv1: CGFloat = 0
        var dv2: CGFloat = 0
        var dv3: CGFloat = 0
        var dv4: CGFloat = 0
        
        integrate(frame.origin.x - target.origin.x, velocity: velocity.origin.x, dxdt: &dp1, dvdt: &dv1, dt: timeElapsed)
        integrate(frame.origin.y - target.origin.y, velocity: velocity.origin.y, dxdt: &dp2, dvdt: &dv2, dt: timeElapsed)
        integrate(frame.size.width - target.size.width, velocity: velocity.size.width, dxdt: &dp3, dvdt: &dv3, dt: timeElapsed)
        integrate(frame.size.height - target.size.height, velocity: velocity.size.height, dxdt: &dp4, dvdt: &dv4, dt: timeElapsed)
        
        let newFrame = CGRect(
            x: frame.origin.x + dp1 * CGFloat(timeElapsed),
            y: frame.origin.y + dp2 * CGFloat(timeElapsed),
            width: frame.size.width + dp3 * CGFloat(timeElapsed),
            height: frame.size.height + dp4 * CGFloat(timeElapsed)
        )
        let newVelocity = CGRect(
            x: velocity.origin.x + dv1 * CGFloat(timeElapsed),
            y: velocity.origin.y + dv2 * CGFloat(timeElapsed),
            width: velocity.size.width + dv3 * CGFloat(timeElapsed),
            height: velocity.size.height + dv4 * CGFloat(timeElapsed)
        )
        
        return (newFrame, newVelocity)
    }
    
    private func isTargetReached(frame: T, target: T) -> Bool {
        let values = frame.values
        let targetValues = target.values
        
        guard values.count == targetValues.count else {
            return false
        }
        
        var targetReached = true
        values.enumerate().forEach { (index, value) in
            targetReached = targetReached && (value - targetValues[index] <= 0.1)
        }
        
        return targetReached
    }
    
}

// MARK: - Protocol conformance

// MARK: Animatable

extension SpringAnimation: Animatable {
    
    func animationTick(timeElapsed: CFTimeInterval, inout finished: Bool) {
        guard let view = view else {
            finished = true
            return
        }
        
        let nextStep = integrate(view.frame, target: target, velocity: velocity, timeElapsed: timeElapsed)
        
        setter(nextStep.frame)
        velocity = nextStep.velocity
        
        if isTargetReached(getter(), target: target) {
            view.frame = target as! CGRect
            finished = true
        }
        
        if let onTick = onTick {
            onTick()
        }
    }
    
}
