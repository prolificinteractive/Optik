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
 
 - parameter images:                Images to be displayed.
 - parameter dismissButtonImage:    Image for the dismiss button.
 - parameter dismissButtonPosition: Dismiss button position.
 
 - returns: The created view controller.
 */
public func imageViewerWithImages(images: [UIImage],
                                  dismissButtonImage: UIImage? = nil,
                                  dismissButtonPosition: DismissButtonPosition = .TopLeading) -> UIViewController {
    return imageViewerWithData(.Local(images: images),
                               dismissButtonImage: dismissButtonImage,
                               dismissButtonPosition: dismissButtonPosition)
}

/**
 Creates and returns a view controller in which images from the specified URLs are downloaded and displayed.
 
 - parameter urls:                   Image URLs.
 - parameter imageDownloader:        Image downloader.
 - parameter activityIndicatorColor: Tint color of the activity indicator that is displayed while images are being downloaded.
 - parameter dismissButtonImage:     Image for the dismiss button.
 - parameter dismissButtonPosition:  Dismiss button position.
 
 - returns: The created view controller.
 */
public func imageViewerWithURLs(urls: [NSURL],
                                imageDownloader: ImageDownloader,
                                activityIndicatorColor: UIColor = .whiteColor(),
                                dismissButtonImage: UIImage? = nil,
                                dismissButtonPosition: DismissButtonPosition = .TopLeading) -> UIViewController {
    return imageViewerWithData(.Remote(urls: urls, imageDownloader: imageDownloader),
                               activityIndicatorColor: activityIndicatorColor,
                               dismissButtonImage: dismissButtonImage,
                               dismissButtonPosition: dismissButtonPosition)
}

// MARK: - Private functions

private func imageViewerWithData(imageData: ImageData,
                                 activityIndicatorColor: UIColor? = nil,
                                 dismissButtonImage: UIImage?,
                                 dismissButtonPosition: DismissButtonPosition) -> UIViewController {
    let bundle = NSBundle(forClass: AlbumViewController.self)
    let defaultDismissButtonImage = UIImage(named: "DismissIcon", inBundle: bundle, compatibleWithTraitCollection: nil)
    
    return AlbumViewController(imageData: imageData,
                               activityIndicatorColor: activityIndicatorColor,
                               dismissButtonImage: (dismissButtonImage != nil) ? dismissButtonImage : defaultDismissButtonImage,
                               dismissButtonPosition: dismissButtonPosition)
}
