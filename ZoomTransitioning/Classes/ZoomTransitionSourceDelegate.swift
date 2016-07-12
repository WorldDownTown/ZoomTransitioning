//
//  ZoomTransitionSourceDelegate.swift
//  Pods
//
//  Created by shoji on 2016/07/12.
//
//

import UIKit

@objc public protocol ZoomTransitionSourceDelegate: NSObjectProtocol {

    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame() -> CGRect
    optional func transitionSourceWillBegin()
    optional func transitionSourceDidEnd()
    optional func transitionSourceDidCancel()
}
