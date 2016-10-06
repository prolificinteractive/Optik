//
//  CustomToolbarController.swift
//  Optik
//
//  Created by Daniel Vancura on 10/5/16.
//
//

import Optik
import UIKit

internal final class CustomToolbarController: ToolbarController {

    let navigationBarHidesOnTap = true

    let toolbarHidesOnTap = true

    let navigationItem: UINavigationItem = UINavigationItem(title: "Photos")

    func setupNavigationBar(navigationBar: UINavigationBar, forUseIn albumViewController: UIViewController) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(share))
    }

    func setupToolbar(toolbar: UIToolbar, forUseIn albumViewController: UIViewController) {
        toolbar.items = [UIBarButtonItem(title: "Nop", style: .Done, target: nil, action: nil)]
    }

    @objc private func share() {

    }

}
