//
//  TransitionAnimator.swift
//  Optik
//
//  Created by Htin Linn on 6/17/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Transition animator.
internal final class TransitionAnimator: NSObject {
    
    /**
     Modal transition type.
     
     - Present: Present.
     - Dismiss: Dimiss.
     */
    enum TransitionType {
        case Present
        case Dismiss
    }
    
    private struct Constants {
        static let AnimationViewShadowColor: CGColor = UIColor.blackColor().CGColor
        static let AnimationViewShadowOffset: CGSize = CGSize(width: 0, height: 20)
        static let AnimationViewShadowRadius: CGFloat = 20
        static let AnimationViewShadowOpacity: Float = 0.35
        
        static let TransitionDuration: NSTimeInterval = 0.235
    }
    
    // MARK: - Private properties
    
    private weak var fromImageView: UIImageView?
    private weak var toImageView: UIImageView?
    private weak var animationView: UIImageView?
    
    private weak var fromViewController: UIViewController?
    private weak var toViewController: UIViewController?
    
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private let transitionType: TransitionType
    
    // MARK: - Init/deinit
    
    init(transitionType: TransitionType, fromImageView: UIImageView, toImageView: UIImageView) {
        self.transitionType = transitionType
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        
        super.init()
    }
    
    // MARK: - Instance functions
    
    /**
     Updates ongoing interactive transition and moves `animationView` by specified translation.
     
     - parameter translation: Translation.
     */
    func updateInteractiveTransition(translation: CGPoint) {
        guard let animationView = animationView else {
            transitionContext?.completeTransition(false)
            return
        }
                
        animationView.frame = CGRectOffset(animationView.frame, translation.x, translation.y)
    }
    
    /**
     Finishes ongoing interactive transition and completes transition animation using specified velocity.
     
     - parameter velocity: Velocity.
     */
    func finishInteractiveTransition(withVelocity velocity: CGPoint) {
        performZoomAnimation(reverse: false, withVelocity: CGRect(origin: velocity, size: CGSize.zero))
    }
    
    /**
     Cancels ongoing interactive transition and reverses transition animation using specified velocity.
     
     - parameter velocity: Velocity.
     */
    func cancelInteractiveTransition(withVelocity velocity: CGPoint) {
        performFadeAnimation(reverse: true)
        performZoomAnimation(reverse: true, withVelocity: CGRect(origin: velocity, size: CGSize.zero))
    }
    
    // MARK: - Private functions
    
    private func performFadeAnimation(reverse shouldAnimateInReverse: Bool) {
        guard
            let transitionContainerView = transitionContext?.containerView(),
            let fromViewController = fromViewController,
            let toViewController = toViewController else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let viewControllerToAnimate: UIViewController
        let initialAlpha: CGFloat
        let finalAlpha: CGFloat
        
        switch transitionType {
        case .Present:
            viewControllerToAnimate = toViewController
            initialAlpha = 0
            finalAlpha = 1
        case .Dismiss:
            viewControllerToAnimate = fromViewController
            initialAlpha = 1
            finalAlpha = 0
        }
        
        viewControllerToAnimate.view.alpha = shouldAnimateInReverse ? finalAlpha : initialAlpha
        
        let fadeAnimation = SpringAnimation(
            view: viewControllerToAnimate.view,
            target: shouldAnimateInReverse ? initialAlpha : finalAlpha,
            velocity: 0,
            property: ViewAlpha()
        )
        
        transitionContainerView.animator().addAnimation(fadeAnimation)
    }
    
    private func performZoomAnimation(reverse shouldAnimateInReverse: Bool, withVelocity velocity: CGRect) {
        guard
            let transitionContainerView = transitionContext?.containerView(),
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let animationView = animationView,
            let fromSuperView = fromImageView.superview,
            let toSuperView = toImageView.superview else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let initialRect = fromSuperView.convertRect(fromImageView.frame, toView: transitionContainerView)
        let finalRect = toSuperView.convertRect(toImageView.frame, toView: transitionContainerView)
        
        if !shouldAnimateInReverse {
            switch transitionType {
            case .Present:
                animationView.clipsToBounds = fromImageView.clipsToBounds
                animationView.contentMode = fromImageView.contentMode
            case .Dismiss:
                animationView.clipsToBounds = toImageView.clipsToBounds
                animationView.contentMode = toImageView.contentMode
            }
            
            animationView.layer.cornerRadius = toImageView.layer.cornerRadius
        }
        
        let zoomAnimation = SpringAnimation(
            view: animationView,
            target: shouldAnimateInReverse ? initialRect : finalRect,
            velocity: velocity,
            property: ViewFrame()
        )
        zoomAnimation.onTick = { finished in
            if finished {
                animationView.removeFromSuperview()
                self.animationView = nil
                
                fromImageView.hidden = false
                toImageView.hidden = false
                
                self.transitionContext?.completeTransition(!shouldAnimateInReverse)
            }
        }
        
        transitionContainerView.animator().addAnimation(zoomAnimation)
    }
    
    private func prepareContainerView() {
        guard
            transitionType == .Present,
            let transitionContainerView = transitionContext?.containerView(),
            let fromView = fromViewController?.view,
            let toView = toViewController?.view else {
                return
        }
        
        transitionContainerView.insertSubview(toView, aboveSubview: fromView)
    }
    
    private func prepareImageViews() {
        guard
            let transitionContainerView = transitionContext?.containerView(),
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let fromSuperView = fromImageView.superview else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let animationView = UIImageView(image: fromImageView.image)
        transitionContainerView.addSubview(animationView)
        self.animationView = animationView
        
        animationView.frame = fromSuperView.convertRect(fromImageView.frame, toView: transitionContainerView)
        animationView.layer.shadowColor = Constants.AnimationViewShadowColor
        animationView.layer.shadowOffset = Constants.AnimationViewShadowOffset
        animationView.layer.shadowRadius = Constants.AnimationViewShadowRadius
        animationView.layer.shadowOpacity = Constants.AnimationViewShadowOpacity
        
        fromImageView.hidden = true
        toImageView.hidden = true
    }

}

// MARK: - Protocol conformance

// MARK: UIViewControllerAnimatedTransitioning

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constants.TransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
        finishInteractiveTransition(withVelocity: CGPoint(x: 0, y: 0))
    }
    
}

// MARK: UIViewControllerInteractiveTransitioning

extension TransitionAnimator: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        prepareContainerView()
        prepareImageViews()
        performFadeAnimation(reverse: false)
    }
    
}
