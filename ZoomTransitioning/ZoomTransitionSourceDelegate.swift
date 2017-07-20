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
    @objc optional func transitionSourceWillBegin(forward: Bool)
    @objc optional func transitionSourceDidEnd(forward: Bool)
    @objc optional func transitionSourceDidCancel()
    
    @objc optional func zoomDuration() -> TimeInterval
    @objc optional func zoomAnimation(animations: @escaping () -> Void, completion: @escaping () -> Void)
}
