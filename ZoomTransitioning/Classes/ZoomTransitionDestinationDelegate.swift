//
//  ZoomTransitionDestinationDelegate.swift
//  Pods
//
//  Created by shoji on 2016/07/12.
//
//

import UIKit

@objc public protocol ZoomTransitionDestinationDelegate: NSObjectProtocol {

    func transitionDestinationImageViewFrame() -> CGRect
    optional func transitionDestinationWillBegin()
    optional func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
}
