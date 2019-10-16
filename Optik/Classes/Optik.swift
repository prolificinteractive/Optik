//
//  Optik.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

// MARK: - Public functions

/**
 Creates and returns a view controller in which the specified images are displayed.
 
 - parameter images:                        Images to be displayed.
 - parameter initialImageDisplayIndex:      Index of first image to display.
 - parameter delegate:                      Image viewer delegate.
 - parameter dismissButtonImage:            Image for the dismiss button.
 - parameter dismissButtonPosition:         Dismiss button position.
 - parameter transitionShadow               Whether to display a shadow to the image or not during transitions.
 
 - returns: The created view controller.
 */
public func imageViewer(withImages images: [UIImage],
                                   initialImageDisplayIndex: Int = 0,
                                   delegate: ImageViewerDelegate? = nil,
                                   dismissButtonImage: UIImage? = nil,
                                   dismissButtonPosition: DismissButtonPosition = .topLeading,
                                   transitionShadow: Bool = true) -> UIViewController {
    let albumViewController = imageViewer(withData: .local(images: images),
                                          initialImageDisplayIndex: initialImageDisplayIndex,
                                          delegate: delegate,
                                          dismissButtonImage: dismissButtonImage,
                                          dismissButtonPosition: dismissButtonPosition,
                                          transitionShadow: transitionShadow)
    
    return albumViewController
}

/**
 Creates and returns a view controller in which images from the specified URLs are downloaded and displayed.
 
 - parameter urls:                          Image URLs.
 - parameter initialImageDisplayIndex:      Index of first image to display.
 - parameter imageDownloader:               Image downloader.
 - parameter activityIndicatorColor:        Tint color of the activity indicator that is displayed while images are being downloaded.
 - parameter dismissButtonImage:            Image for the dismiss button.
 - parameter dismissButtonPosition:         Dismiss button position.
 - parameter transitionShadow               Whether to display a shadow to the image or not during transitions.
 
 - returns: The created view controller.
 */
public func imageViewer(withURLs urls: [URL],
                                 initialImageDisplayIndex: Int = 0,
                                 delegate: ImageViewerDelegate? = nil,
                                 imageDownloader: ImageDownloader,
                                 activityIndicatorColor: UIColor = .white,
                                 dismissButtonImage: UIImage? = nil,
                                 dismissButtonPosition: DismissButtonPosition = .topLeading,
                                 transitionShadow: Bool = true) -> UIViewController {
    return imageViewer(withData: .remote(urls: urls, imageDownloader: imageDownloader),
                       initialImageDisplayIndex: initialImageDisplayIndex,
                       delegate: delegate,
                       activityIndicatorColor: activityIndicatorColor,
                       dismissButtonImage: dismissButtonImage,
                       dismissButtonPosition: dismissButtonPosition,
                       transitionShadow: transitionShadow)
}

// MARK: - Private functions

private func imageViewer(withData imageData: ImageData,
                                  initialImageDisplayIndex: Int,
                                  delegate: ImageViewerDelegate? = nil,
                                  activityIndicatorColor: UIColor? = nil,
                                  dismissButtonImage: UIImage?,
                                  dismissButtonPosition: DismissButtonPosition,
                                  transitionShadow: Bool) -> AlbumViewController {
    let bundle = Bundle(for: AlbumViewController.self)
    let defaultDismissButtonImage = UIImage(named: "DismissIcon", in: bundle, compatibleWith: nil)

    let albumViewController = AlbumViewController(imageData: imageData,
                                                  initialImageDisplayIndex: initialImageDisplayIndex,
                                                  activityIndicatorColor: activityIndicatorColor,
                                                  dismissButtonImage: dismissButtonImage ?? defaultDismissButtonImage,
                                                  dismissButtonPosition: dismissButtonPosition,
                                                  transitionShadow: transitionShadow)
    albumViewController.modalPresentationCapturesStatusBarAppearance = true
    albumViewController.modalPresentationStyle = .custom
    albumViewController.imageViewerDelegate = delegate
    
    return albumViewController
}
