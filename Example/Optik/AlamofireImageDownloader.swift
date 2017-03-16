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
    
    func downloadImage(from url: URL, completion: @escaping ImageDownloaderCompletion) {
        let URLRequest = Foundation.URLRequest(url: url)
        
        internalImageDownloader.download(URLRequest) {
            response in
            
            switch response.result {
            case .success(let image):
                completion(image)
            case .failure(_):
                // Hanlde error
                return
            }
        }
    }
    
}
