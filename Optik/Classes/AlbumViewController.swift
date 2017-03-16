//
//  AlbumViewController.swift
//  Optik
//
//  Created by Htin Linn on 5/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller for displaying a collection of photos.
internal final class AlbumViewController: UIViewController {
    
    private struct Constants {
        static let SpacingBetweenImages: CGFloat = 40
        static let DismissButtonDimension: CGFloat = 60
        
        static let TransitionAnimationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Properties
    
    weak var imageViewerDelegate: ImageViewerDelegate? {
        didSet {
            guard let _ = imageViewerDelegate else {
                transitioningDelegate = nil
                
                transitionController.currentImageView = nil
                transitionController.transitionImageView = nil
                
                return
            }
            
            transitioningDelegate = transitionController
            
            transitionController.viewControllerToDismiss = self
            transitionController.currentImageView = { [weak self] in
                return self?.currentImageViewController?.imageView
            }
            transitionController.transitionImageView = { [weak self] in
                guard let currentImageIndex = self?.currentImageViewController?.index else {
                    return nil
                }
                
                return self?.imageViewerDelegate?.transitionImageView(for: currentImageIndex)
            }
        }
    }
    
    // MARK: Override properties
    
    override var prefersStatusBarHidden : Bool {
        return viewDidAppear
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: Private properties
    
    private var pageViewController: UIPageViewController
    fileprivate var currentImageViewController: ImageViewController? {
        guard let viewControllers = pageViewController.viewControllers, viewControllers.count == 1 else {
            return nil
        }
        
        return viewControllers[0] as? ImageViewController
    }
    
    fileprivate var imageData: ImageData
    private var initialImageDisplayIndex: Int
    private var activityIndicatorColor: UIColor?
    private var dismissButtonImage: UIImage?
    private var dismissButtonPosition: DismissButtonPosition
    
    private var cachedRemoteImages: [URL: UIImage] = [:]
    private var viewDidAppear: Bool = false
    
    private var transitionController: TransitionController = TransitionController()
    
    fileprivate var pageControl: UIPageControl?
    
    // MARK: - Init/Deinit
    
    init(imageData: ImageData,
         initialImageDisplayIndex: Int,
         activityIndicatorColor: UIColor?,
         dismissButtonImage: UIImage?,
         dismissButtonPosition: DismissButtonPosition,
         enablePageControl: Bool) {
        
        self.imageData = imageData
        self.initialImageDisplayIndex = initialImageDisplayIndex
        self.activityIndicatorColor = activityIndicatorColor
        self.dismissButtonImage = dismissButtonImage
        self.dismissButtonPosition = dismissButtonPosition
        
        if enablePageControl {
            pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .vertical,
                                                  options: [UIPageViewControllerOptionInterPageSpacingKey : Constants.SpacingBetweenImages])
            pageControl = UIPageControl()
        } else {
            pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: [UIPageViewControllerOptionInterPageSpacingKey : Constants.SpacingBetweenImages])
        }

        super.init(nibName: nil, bundle: nil)
        
        setupPageViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid initializer.")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // HACK: UIKit doesn't animate status bar transition on iOS 9. So, manually animate it.
        if !viewDidAppear {
            viewDidAppear = true
            
            UIView.animate(withDuration: Constants.TransitionAnimationDuration, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            }) 
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        cachedRemoteImages = [:]
    }
    
    // MARK: - Private functions
    
    private func setupDesign() {
        view.backgroundColor = UIColor.black
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        didMove(toParentViewController: pageViewController)
        
        setupDismissButton()
        setupPageControl()
        setupPanGestureRecognizer()
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set up initial image view controller.
        if let imageViewController = imageViewController(forIndex: initialImageDisplayIndex) {
            pageViewController.setViewControllers([imageViewController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
        }
    }
    
    private func setupPageControl() {
        
        if let page = pageControl {
            page.currentPage = initialImageDisplayIndex
            page.pageIndicatorTintColor = UIColor.red
            page.translatesAutoresizingMaskIntoConstraints = false
            page.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/2))
            view.addSubview(page)
            
            view.addConstraint(
                NSLayoutConstraint(item: page,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: -10)
            )
            view.addConstraint(
                NSLayoutConstraint(item: page,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .centerY,
                                   multiplier: 1,
                                   constant: 0)
            )
            view.addConstraint(
                NSLayoutConstraint(item: page,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: 30)
            )
            view.addConstraint(
                NSLayoutConstraint(item: page,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: 25)
            )
        }
        
    }
    
    
    private func setupDismissButton() {
        let dismissButton = UIButton(type: .custom)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(dismissButtonImage, for: UIControlState())
        dismissButton.addTarget(self, action: #selector(AlbumViewController.didTapDismissButton(_:)), for: .touchUpInside)
        
        let xAnchorAttribute = dismissButtonPosition.xAnchorAttribute()
        let yAnchorAttribute = dismissButtonPosition.yAnchorAttribute()
        
        view.addSubview(dismissButton)
        
        view.addConstraint(
            NSLayoutConstraint(item: dismissButton,
                attribute: xAnchorAttribute,
                relatedBy: .equal,
                toItem: view,
                attribute: xAnchorAttribute,
                multiplier: 1,
                constant: 0)
        )
        view.addConstraint(
            NSLayoutConstraint(item: dismissButton,
                attribute: yAnchorAttribute,
                relatedBy: .equal,
                toItem: view,
                attribute: yAnchorAttribute,
                multiplier: 1,
                constant: 0)
        )
        view.addConstraint(
            NSLayoutConstraint(item: dismissButton,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: Constants.DismissButtonDimension)
        )
        view.addConstraint(
            NSLayoutConstraint(item: dismissButton,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: Constants.DismissButtonDimension)
        )
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AlbumViewController.didPan(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    fileprivate func imageViewController(forIndex index: Int) -> ImageViewController? {
        switch imageData {
        case .local(let images):
            guard index >= 0 && index < images.count else {
                return nil
            }
            
            pageControl?.numberOfPages = images.count
            return ImageViewController(image: images[index], index: index)
        case .remote(let urls, let imageDownloader):
            guard index >= 0 && index < urls.count else {
                return nil
            }
            
            pageControl?.numberOfPages = urls.count
            let imageViewController = ImageViewController(activityIndicatorColor: activityIndicatorColor, index: index)
            let url = urls[index]
            
            if let image = cachedRemoteImages[url] {
                imageViewController.image = image
            } else {
                imageDownloader.downloadImage(from: url, completion: {
                    [weak self] (image) in
                    
                    self?.cachedRemoteImages[url] = image
                    imageViewController.image = image
                    })
            }

            
            return imageViewController
        }
    }
    
    @objc private func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        transitionController.didPan(withGestureRecognizer: sender, sourceView: view)
    }
    
}

// MARK: - Protocol conformance

// MARK: UIPageViewControllerDataSource

extension AlbumViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? ImageViewController else {
            return nil
        }
        
        return self.imageViewController(forIndex: imageViewController.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? ImageViewController else {
            return nil
        }
        
        return self.imageViewController(forIndex: imageViewController.index + 1)
    }
    
}

// MARK: UIPageViewControllerDelegate

extension AlbumViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        
        if previousViewControllers.count > 0 {
            previousViewControllers
                .map { $0 as? ImageViewController }
                .forEach { $0?.resetImageView() }
        }
        
        if let currentImageIndex = currentImageViewController?.index {
            imageViewerDelegate?.imageViewerDidDisplayImage(at: currentImageIndex)
            pageControl?.currentPage = currentImageIndex
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        return .max
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return numberOfImages()
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentImageViewController?.index ?? 0
    }
    
    private func numberOfImages() -> Int {
        switch imageData {
        case .local(images: let images):
            return images.count
        case .remote(urls: let urls, imageDownloader: _):
            return urls.count
        }
    }
    
}
