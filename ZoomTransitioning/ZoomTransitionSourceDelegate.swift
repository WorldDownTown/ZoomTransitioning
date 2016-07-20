//
//  ZoomTransitionSourceDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame(forward forward: Bool) -> CGRect
    func transitionSourceWillBegin()
    func transitionSourceDidEnd()
    func transitionSourceDidCancel()
}

extension ZoomTransitionSourceDelegate {

    func transitionSourceWillBegin() { /* Optional */ }
    func transitionSourceDidEnd() { /* Optional */ }
    func transitionSourceDidCancel() { /* Optional */ }
}
