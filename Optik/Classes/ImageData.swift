//
//  ImageData.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

internal enum ImageData {
    
    case Local(images: [UIImage])
    case Remote(urls: [NSURL], imageDownloader: ImageDownloader)
    
}
