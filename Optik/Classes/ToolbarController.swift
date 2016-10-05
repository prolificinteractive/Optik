//
//  ToolbarController.swift
//  Pods
//
//  Created by Daniel Vancura on 10/5/16.
//
//

import UIKit

public protocol ToolbarController: class {

    /// Indicates whether the navigation bar should hide on a tap gesture.
    var navigationBarHidesOnTap: Bool { get }

    /// Indicates whether the toolbar should hide on a tap gesture.
    var toolbarHidesOnTap: Bool { get }

    /// The navigation item which will be displayed in the album view's navigation bar.
    var navigationItem: UINavigationItem { get }

    /// Sets up the given navigation bar before adding it to the album view controller.
    ///
    /// - parameter navigationBar: The album view controller's navigation bar.
    func setup(navigationBar: UINavigationBar, forUseIn albumViewController: UIViewController)

    /// Sets up the given toolbar before adding it to the album view contorller.
    ///
    /// - parameter toolbar: The album view controller's toolbar.
    func setup(toolbar: UIToolbar, forUseIn albumViewController: UIViewController)

}
