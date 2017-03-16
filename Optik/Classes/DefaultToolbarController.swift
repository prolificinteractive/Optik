//
//  DefaultToolbarController.swift
//  Pods
//
//  Created by Daniel Vancura on 10/5/16.
//
//

import UIKit

internal final class DefaultToolbarController: ToolbarController {

    // MARK: - Parameters

    let navigationItem: UINavigationItem = UINavigationItem(title: "")

    let navigationBarHidesOnTap: Bool = true

    let toolbarHidesOnTap: Bool = true

    // MARK: - Functions

    func setupNavigationBar(navigationBar: UINavigationBar, forUseIn albumViewController: UIViewController) {
        navigationBar.barStyle = .BlackTranslucent
    }

    func setupToolbar(toolbar: UIToolbar, forUseIn albumViewController: UIViewController) {
        toolbar.barStyle = .BlackTranslucent
    }

}
