//
//  ZoomTransitionSourceDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

@objc public protocol ZoomTransitionSourceDelegate: NSObjectProtocol {

    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    @objc optional func transitionSourceWillBegin()
    @objc optional func transitionSourceDidEnd()
    @objc optional func transitionSourceDidCancel()
}
