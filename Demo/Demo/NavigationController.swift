//
//  NavigationController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/09/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
    private let zoomNavigationControllerDelegate: ZoomNavigationControllerDelegate = .init()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = zoomNavigationControllerDelegate
    }
}
