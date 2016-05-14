//
//  ViewController.swift
//  Optik
//
//  Created by Htin Linn on 05/14/2016.
//  Copyright (c) 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import Optik

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = Optik.imageViewerWithImages([])
        presentViewController(viewController, animated: true, completion: nil)
    }
    
}

