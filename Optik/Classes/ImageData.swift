//
//  ImageData.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 Defines and encapulates various image data types.
 
 - Local:  Local images.
 - Remote: Remote images that can be downloaded from specified URLs using given image downloader.
 */
internal enum ImageData {
    
    case Local(images: [UIImage])
    case Remote(urls: [NSURL], imageDownloader: ImageDownloader)
    
}
