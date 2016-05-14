//
//  ViewController.swift
//  Optik
//
//  Created by Htin Linn on 05/14/2016.
//  Copyright (c) 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import Optik

internal final class ViewController: UIViewController {

    @IBAction private func presentLocalImageViewer(sender: UIButton) {
        let viewController = Optik.imageViewerWithImages([
            UIImage(named: "super_blood_moon.jpg")!,
            UIImage(named: "cats.jpg")!,
            UIImage(named: "life.jpg")!,
            UIImage(named: "whiteboard.jpg")!
            ])
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction private func presentRemoteImageViewer(sender: UIButton) {
        guard
            let url1 = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/9/96/BURN_THE_WITCH.png"),
            let url2 = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/9/9b/Croissant%2C_cross_section.jpg"),
            let url3 = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/9/9d/Link_%28Hyrule_Historia%29.png"),
            let url4 = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/3/34/RickAstleyNeverGonnaGiveYouUp7InchSingleCover.jpg") else {
                return
        }
        
        let urls = [url1, url2, url3, url4]
        let imageDownloader = AlamofireImageDownloader()
        
        let viewController = Optik.imageViewerWithURLs(urls, imageDownloader: imageDownloader)
        presentViewController(viewController, animated: true, completion: nil)
    }

}

