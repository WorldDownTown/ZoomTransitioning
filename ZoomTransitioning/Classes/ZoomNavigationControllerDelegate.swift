//
//  ZoomNavigationControllerDelegate.swift
//  Pods
//
//  Created by shoji on 7/16/16.
//
//

import UIKit

public final class ZoomNavigationControllerDelegate: NSObject {

    private let zoomInteractiveTransitioning = ZoomInteractiveTransitioning()
}


// MARK: - UINavigationControllerDelegate

extension ZoomNavigationControllerDelegate: UINavigationControllerDelegate {

    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        if let gestureRecognizer = navigationController.interactivePopGestureRecognizer where gestureRecognizer.delegate !== zoomInteractiveTransitioning {
            gestureRecognizer.delegate = zoomInteractiveTransitioning
            gestureRecognizer.addTarget(zoomInteractiveTransitioning, action: #selector(ZoomInteractiveTransitioning.handlePanGestureRecognizer(_:)))
        }

        return zoomInteractiveTransitioning.interactionControllerForAnimationController(animationController)
    }

    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let source = fromVC as? ZoomTransitionSourceDelegate, destination = toVC as? ZoomTransitionDestinationDelegate where operation == .Push {
            return ZoomTransitioning(source: source, destination: destination, forward: true)
        } else if let source = toVC as? ZoomTransitionSourceDelegate, destination = fromVC as? ZoomTransitionDestinationDelegate where operation == .Pop {
            return ZoomTransitioning(source: source, destination: destination, forward: false)
        }
        return nil
    }
}
