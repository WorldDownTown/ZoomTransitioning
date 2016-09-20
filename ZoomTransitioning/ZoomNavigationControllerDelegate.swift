//
//  ZoomNavigationControllerDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomNavigationControllerDelegate: NSObject {

    fileprivate let zoomInteractiveTransition = ZoomInteractiveTransition()
}


// MARK: - UINavigationControllerDelegate

extension ZoomNavigationControllerDelegate: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        if let gestureRecognizer = navigationController.interactivePopGestureRecognizer, gestureRecognizer.delegate !== zoomInteractiveTransition {
            zoomInteractiveTransition.navigationController = navigationController
            gestureRecognizer.delegate = zoomInteractiveTransition
            gestureRecognizer.addTarget(zoomInteractiveTransition, action: #selector(ZoomInteractiveTransition.handle(recognizer:)))
        }

        return zoomInteractiveTransition.interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let source = fromVC as? ZoomTransitionSourceDelegate, let destination = toVC as? ZoomTransitionDestinationDelegate, operation == .push {
            return ZoomTransitioning(source: source, destination: destination, forward: true)
        } else if let source = toVC as? ZoomTransitionSourceDelegate, let destination = fromVC as? ZoomTransitionDestinationDelegate, operation == .pop {
            return ZoomTransitioning(source: source, destination: destination, forward: false)
        }
        return nil
    }
}
