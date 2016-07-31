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
    
    private struct Constants {
        static let DefaultTransitionDuration: NSTimeInterval = 0.235
    }
    
    enum TransitionType {
        case Present
        case Dismiss
    }
    
    // MARK: - Private properties
    
    private weak var fromImageView: UIImageView?
    private weak var toImageView: UIImageView?
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
    
    func updateInteractiveTransition(translation: CGPoint) {
        
    }
    
    // MARK: - Private functions
    
    private func finishInteractiveTransition(withVelocity velocity: CGPoint) {
        performZoomAnimation(withVelocity: CGRect(origin: velocity, size: CGSize.zero))
    }
    
    private func performFadeAnimation() {
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
        
        viewControllerToAnimate.view.alpha = initialAlpha
        
        let fadeAnimation = SpringAnimation(
            view: viewControllerToAnimate.view,
            target: finalAlpha,
            velocity: 0,
            property: ViewAlpha()
        )
        
        transitionContainerView.animator().addAnimation(fadeAnimation)
    }
    
    private func performZoomAnimation(withVelocity velocity: CGRect) {
        guard
            let transitionContainerView = transitionContext?.containerView(),
            let toViewController = toViewController,
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let fromSuperView = fromImageView.superview,
            let toSuperView = toImageView.superview else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let transitionImageView = UIImageView(image: fromImageView.image)
        transitionImageView.frame = fromSuperView.convertRect(fromImageView.frame, toView: transitionContainerView)
        transitionImageView.layer.cornerRadius = toImageView.layer.cornerRadius
        
        switch transitionType {
        case .Present:
            transitionImageView.contentMode = fromImageView.contentMode
            transitionImageView.clipsToBounds = fromImageView.clipsToBounds
        case .Dismiss:
            transitionImageView.contentMode = toImageView.contentMode
            transitionImageView.clipsToBounds = toImageView.clipsToBounds
        }
        
        transitionContainerView.addSubview(transitionImageView)
        fromImageView.hidden = true
        toImageView.hidden = true
        
        let zoomAnimation = SpringAnimation(
            view: transitionImageView,
            target: toSuperView.convertRect(toImageView.frame, toView: transitionContainerView),
            velocity: velocity,
            property: ViewFrame()
        )
        zoomAnimation.onTick = { finished in
            if finished {
                transitionImageView.removeFromSuperview()
                toImageView.hidden = false
                
                self.transitionContext?.completeTransition(true)
            }
        }
        
        transitionContainerView.animator().addAnimation(zoomAnimation)
    }
    
    private func prepareContainerView() {
        guard
            transitionType == .Present,
            let transitionContext = transitionContext,
            let fromView = fromViewController?.view,
            let toView = toViewController?.view else {
                return
        }
        
        transitionContext.containerView()?.insertSubview(toView, aboveSubview: fromView)
    }

}

// MARK: - Protocol conformance

// MARK: UIViewControllerAnimatedTransitioning

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constants.DefaultTransitionDuration
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
        performFadeAnimation()
    }
    
}
