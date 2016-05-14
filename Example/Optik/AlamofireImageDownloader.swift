//
//  AlamofireImageDownloader.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Optik
import AlamofireImage

internal struct AlamofireImageDownloader: Optik.ImageDownloader {
    
    private let internalImageDownloader = AlamofireImage.ImageDownloader()
    
    func downloadImageAtURL(url: NSURL, completion: ImageDownloaderCompletion) {
        let URLRequest = NSURLRequest(URL: url)
        
        internalImageDownloader.downloadImage(URLRequest: URLRequest) {
            response in
            
            switch response.result {
            case .Success(let image):
                completion(image)
            case .Failure(_):
                // Hanlde error
                return
            }
        }
    }
    
}
