//
//  ZoomTransitionDestinationDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

@objc public protocol ZoomTransitionDestinationDelegate: NSObjectProtocol {

    func transitionDestinationImageViewFrame(forward forward: Bool) -> CGRect
    optional func transitionDestinationWillBegin()
    optional func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
    optional func transitionDestinationDidCancel()
}
