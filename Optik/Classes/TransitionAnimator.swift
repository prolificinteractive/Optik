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
        static let DefaultTransitionDuration: NSTimeInterval = 0.35
    }
    
    enum TransitionType {
        case Present
        case Dismiss
    }
    
    // MARK: - Private properties
    
    private let transitionType: TransitionType
    private weak var fromImageView: UIImageView?
    private weak var toImageView: UIImageView?

    // MARK: - Init/deinit
    
    init(transitionType: TransitionType, fromImageView: UIImageView, toImageView: UIImageView) {
        self.transitionType = transitionType
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        
        super.init()
    }

}

// MARK: - Protocol conformance

// MARK: UIViewControllerAnimatedTransitioning

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constants.DefaultTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let transitionContainerView = transitionContext.containerView() else {
                return
        }
        
        transitionContainerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        var zoomAnimation: (() -> ())?
        var zoomAnimationCompletion: (() -> ())?
        
        if
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let fromSuperView = fromImageView.superview,
            let toSuperView = toImageView.superview {
            
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
            
            zoomAnimation = {
                transitionImageView.frame = toSuperView.convertRect(toImageView.frame, toView: transitionContainerView)
            }
            zoomAnimationCompletion = {
                transitionImageView.removeFromSuperview()
                toImageView.hidden = false
            }
        }

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            animations: {
                zoomAnimation?()
                toViewController.view.alpha = 1
            },
            completion: { _ in
                zoomAnimationCompletion?()
                transitionContext.completeTransition(true)
            }
        )
    }
    
}

