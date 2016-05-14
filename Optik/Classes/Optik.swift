//
//  Optik.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public struct Optik {
    
    // MARK: - Static functions
    
    static func imageViewerWithImages(images: [UIImage],
                                      dismissButtonImage: UIImage? = UIImage(named: "DismissIcon"),
                                      dismissButtonPosition: DismissButtonPosition = .TopLeading) -> UIViewController {
        return imageViewerWithData(.Local(images: images),
                                   dismissButtonImage: dismissButtonImage,
                                   dismissButtonPosition: dismissButtonPosition)
    }
    
    static func imageViewerWithURLs(urls: [NSURL],
                                    imageDownloader: ImageDownloader,
                                    activityIndicatorColor: UIColor = .whiteColor(),
                                    dismissButtonImage: UIImage? = UIImage(named: "DismissIcon"),
                                    dismissButtonPosition: DismissButtonPosition = .TopLeading) -> UIViewController {
        return imageViewerWithData(.Remote(urls: urls, imageDownloader: imageDownloader),
                                   activityIndicatorColor: activityIndicatorColor,
                                   dismissButtonImage: dismissButtonImage,
                                   dismissButtonPosition: dismissButtonPosition)
    }
    
    // MARK: - Private functions
    
    private static func imageViewerWithData(imageData: ImageData,
                                            activityIndicatorColor: UIColor? = nil,
                                            dismissButtonImage: UIImage?,
                                            dismissButtonPosition: DismissButtonPosition) -> UIViewController {
        return AlbumViewController(imageData: imageData,
                                   activityIndicatorColor: activityIndicatorColor,
                                   dismissButtonImage: dismissButtonImage,
                                   dismissButtonPosition: dismissButtonPosition)
    }
    
}
