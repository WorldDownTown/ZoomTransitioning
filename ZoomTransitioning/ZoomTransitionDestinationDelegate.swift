//
//  ZoomTransitionDestinationDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionDestinationDelegate {
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
    func transitionDestinationWillBegin()
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
    func transitionDestinationDidCancel()
}

public extension ZoomTransitionDestinationDelegate {
    func transitionDestinationWillBegin() {}
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {}
    func transitionDestinationDidCancel() {}
}
