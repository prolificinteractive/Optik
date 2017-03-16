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
    
    // MARK: - Private properties
    
    @IBOutlet private weak var localImagesButton: UIButton!
    
    private var currentLocalImageIndex = 0 {
        didSet {
            localImagesButton.setImage(localImages[currentLocalImageIndex], forState: .Normal)
        }
    }
    private let localImages: [UIImage] = [
        UIImage(named: "cats.jpg")!,
        UIImage(named: "super_blood_moon.jpg")!,
        UIImage(named: "life.jpg")!,
        UIImage(named: "whiteboard.jpg")!
    ]
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
    }
    
    // MARK: - Private functions
    
    private func setupDesign() {
        localImagesButton.imageView?.layer.cornerRadius = 5
        localImagesButton.imageView?.contentMode = .ScaleAspectFill
    }

    @IBAction private func presentLocalImageViewer(sender: UIButton) {
        let viewController = Optik.imageViewer(withImages: localImages,
                                               initialImageDisplayIndex: currentLocalImageIndex,
                                               delegate: self,
                                               toolbarController: CustomToolbarController())
        
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
        
        let viewController = Optik.imageViewer(withURLs: urls, imageDownloader: imageDownloader)
        presentViewController(viewController, animated: true, completion: nil)
    }

}

// MARK: - Protocol conformance

// MARK: ImageViewerDelegate

extension ViewController: ImageViewerDelegate {
    
    func transitionImageView(forIndex index: Int) -> UIImageView {
        return localImagesButton.imageView!
    }
    
    func imageViewerDidDisplayImage(atIndex index: Int) {
        currentLocalImageIndex = index
    }
    
}
