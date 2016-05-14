//
//  ImageDownloader.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public typealias ImageDownloaderCompletion = UIImage -> ()

public protocol ImageDownloader {
    
    func downloadImageAtURL(url: NSURL, completion: ImageDownloaderCompletion)
    
}
