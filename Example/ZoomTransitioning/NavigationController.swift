//
//  NavigationController.swift
//  ZoomTransitioning
//
//  Created by shoji on 2016/07/09.
//  Copyright © 2016年 CocoaPods. All rights reserved.
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
