//
//  NavigationExtension.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
