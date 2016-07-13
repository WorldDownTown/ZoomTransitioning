//
//  NavigationController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/09/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit
import ZoomTransitioning

class NavigationController: UINavigationController {

    private let zoomTransitioning = ZoomTransitioning()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = zoomTransitioning
    }
}
