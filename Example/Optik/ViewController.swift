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

}

