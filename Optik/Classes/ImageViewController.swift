//
//  ImageViewController.swift
//  Optik
//
//  Created by Htin Linn on 5/5/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller for displaying a single photo.
internal final class ImageViewController: UIViewController {
    
    fileprivate struct Constants {
        static let MaximumZoomScale: CGFloat = 3
        static let MinimumZoomScale: CGFloat = 1
        static let ZoomAnimationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Properties
    
    var image: UIImage? {
        didSet {
            imageView?.image = image
            resetImageView()
            
            if let _ = image {
                activityIndicatorView?.stopAnimating()
            }
        }
    }
    private(set) var imageView: UIImageView?
    var actionButton: UIButton?
    
    let index: Int
    
    // MARK: - Private properties
    
    private var activityIndicatorColor: UIColor?
    private var actionButtonPosition: ActionButtonPosition?

    private var scrollView: UIScrollView? {
        didSet {
            guard let scrollView = scrollView else {
                return
            }
            
            scrollView.decelerationRate = UIScrollViewDecelerationRateFast
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.minimumZoomScale = Constants.MinimumZoomScale
            scrollView.maximumZoomScale = Constants.MaximumZoomScale
        }
    }
    private var activityIndicatorView: UIActivityIndicatorView? {
        didSet {
            activityIndicatorView?.color = activityIndicatorColor
        }
    }
    
    private var effectiveImageSize: CGSize?

    // MARK: - Init/Deinit
    
    init(image: UIImage? = nil, activityIndicatorColor: UIColor? = nil, index: Int, actionButtonPosition: ActionButtonPosition) {
        self.image = image
        self.activityIndicatorColor = activityIndicatorColor
        self.index = index
        self.actionButtonPosition = actionButtonPosition
        super.init(nibName: nil, bundle: nil)
        self.actionButton = UIButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid initializer.")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            let oldSize = self.scrollView?.bounds.size
            let newSize = size
            
            self.scrollView?.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            if oldSize != newSize {
                self.resetImageView()
            }
            }, completion: nil)
    }
    
    // MARK: - Instance functions
    
    /**
     Resets and re-centers the image view.
     */
    func resetImageView() {
        scrollView?.zoomScale = Constants.MinimumZoomScale
        
        calculateEffectiveImageSize()
        if let effectiveImageSize = effectiveImageSize {
            imageView?.frame = CGRect(x: 0, y: 0, width: effectiveImageSize.width, height: effectiveImageSize.height)
            scrollView?.contentSize = effectiveImageSize
        }
        
        centerImage()
    }
    
    // MARK: - Private functions
    
    private func setupDesign() {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let imageView = UIImageView(frame: scrollView.bounds)
        scrollView.addSubview(imageView)
        
        self.scrollView = scrollView
        self.imageView = imageView
        
        if let image = image {
            imageView.image = image
            resetImageView()
        } else {
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.startAnimating()
            
            view.addSubview(activityIndicatorView)
            
            view.addConstraint(
                NSLayoutConstraint(item: activityIndicatorView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0)
            )
            view.addConstraint(
                NSLayoutConstraint(item: activityIndicatorView,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: .centerY,
                    multiplier: 1,
                    constant: 0)
            )
            
            self.activityIndicatorView = activityIndicatorView
        }
        
        if let button = actionButton {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleAspectFill
            
            let xAnchorAttribute = actionButtonPosition?.xAnchorAttribute()
            let yAnchorAttribute = actionButtonPosition?.yAnchorAttribute()
            
            view.addSubview(button)
            if let xAnchor = xAnchorAttribute,
                let yAnchor = yAnchorAttribute {
                
                view.addConstraint(
                    NSLayoutConstraint(item: button,
                                       attribute: yAnchor,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: yAnchor,
                                       multiplier: 1,
                                       constant: -20)
                )
                view.addConstraint(
                    NSLayoutConstraint(item: button,
                                       attribute: xAnchor,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: xAnchor,
                                       multiplier: 1,
                                       constant: 20)
                )
                view.addConstraint(
                    NSLayoutConstraint(item: button,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .width,
                                       multiplier: 1,
                                       constant: 44)
                )
                view.addConstraint(
                    NSLayoutConstraint(item: button,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .height,
                                       multiplier: 1,
                                       constant: 44)
                )
            }
            
        }
        
        setupTapGestureRecognizer()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.didDoubleTap(_:)))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.numberOfTapsRequired = 2 // Only allow double tap.
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func calculateEffectiveImageSize() {
        guard
            let image = image,
            let scrollView = scrollView else {
                return
        }
        
        let imageViewSize = scrollView.frame.size
        let imageSize = image.size
        
        let widthFactor = imageViewSize.width / imageSize.width
        let heightFactor = imageViewSize.height / imageSize.height
        let scaleFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor
        
        effectiveImageSize = CGSize(width: scaleFactor * imageSize.width, height: scaleFactor * imageSize.height)
    }
    
    fileprivate func centerImage() {
        guard
            let effectiveImageSize = effectiveImageSize,
            let scrollView = scrollView else {
                return
        }
        
        let scaledImageSize = CGSize(width: effectiveImageSize.width * scrollView.zoomScale,
                                     height: effectiveImageSize.height * scrollView.zoomScale)
        
        let verticalInset: CGFloat
        let horizontalInset: CGFloat
        
        if scrollView.frame.size.width > scaledImageSize.width {
            horizontalInset = (scrollView.frame.size.width - scrollView.contentSize.width) / 2
        } else {
            horizontalInset = 0
        }
        
        if scrollView.frame.size.height > scaledImageSize.height {
            verticalInset = (scrollView.frame.size.height - scrollView.contentSize.height) / 2
        } else {
            verticalInset = 0
        }
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
        guard
            let effectiveImageSize = effectiveImageSize,
            let imageView = imageView,
            let scrollView = scrollView else {
                return
        }
        
        let tapPointInContainer = sender.location(in: view)
        let scrollViewSize = scrollView.frame.size
        let scaledImageSize = CGSize(width: effectiveImageSize.width * scrollView.zoomScale,
                                     height: effectiveImageSize.height * scrollView.zoomScale)
        let scaledImageRect = CGRect(x: (scrollViewSize.width - scaledImageSize.width) / 2,
                                     y: (scrollViewSize.height - scaledImageSize.height) / 2,
                                     width: scaledImageSize.width,
                                     height: scaledImageSize.height)
        
        guard scaledImageRect.contains(tapPointInContainer) else {
            return
        }
        
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            // Zoom out if the image was zoomed in at all.
            UIView.animate(
                withDuration: Constants.ZoomAnimationDuration,
                delay: 0,
                options: [],
                animations: {
                    scrollView.zoomScale = scrollView.minimumZoomScale
                    self.centerImage()
                },
                completion: nil
            )
        } else {
            // Otherwise, zoom into the location of the tap point.
            let width = scrollViewSize.width / scrollView.maximumZoomScale
            let height = scrollViewSize.height / scrollView.maximumZoomScale
            
            let tapPointInImageView = sender.location(in: imageView)
            let originX = tapPointInImageView.x - (width / 2)
            let originY = tapPointInImageView.y - (height / 2)
            
            let zoomRect = CGRect(x: originX, y: originY, width: width, height: height)
            
            UIView.animate(
                withDuration: Constants.ZoomAnimationDuration,
                delay: 0,
                options: [],
                animations: {
                    scrollView.zoom(to: zoomRect.enclose(imageView.bounds), animated: false)
                },
                completion: { (_) in
                    self.centerImage()
                }
            )
        }
    }
    
}

// MARK: - Protocol conformance

// MARK: UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: Constants.ZoomAnimationDuration, animations: {
            self.centerImage()
        })
    }
    
}
