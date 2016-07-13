//
//  ZoomTransitionDestinationDelegate.swift
//  Pods
//
//  Created by shoji on 2016/07/12.
//
//

import UIKit

@objc public protocol ZoomTransitionDestinationDelegate: NSObjectProtocol {

    func transitionDestinationImageViewFrame(forward forward: Bool) -> CGRect
    optional func transitionDestinationWillBegin()
    optional func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
    optional func transitionDestinationDidCancel()
}
