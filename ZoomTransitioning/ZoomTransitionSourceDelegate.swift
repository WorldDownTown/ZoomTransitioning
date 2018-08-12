//
//  ZoomTransitionSourceDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionSourceDelegate {
    var animationDuration: TimeInterval { get }
    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    func transitionSourceWillBegin()
    func transitionSourceDidEnd()
    func transitionSourceDidCancel()
    func zoomAnimation(animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}

extension ZoomTransitionSourceDelegate {
    var animationDuration: TimeInterval { return 0.3 }
    func transitionSourceWillBegin() {}
    func transitionSourceDidEnd() {}
    func transitionSourceDidCancel() {}
    func zoomAnimation(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
    }
}
