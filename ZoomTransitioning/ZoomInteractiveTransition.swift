//
//  ZoomInteractiveTransition.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var navigationController: UINavigationController?
    weak var zoomPopGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private weak var viewController: UIViewController?
    private var interactive: Bool = false

    var interactionController: ZoomInteractiveTransition? {
        return interactive ? self : nil
    }

    @objc func handle(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translation(in: view).x / view.bounds.width
            update(progress)
        case .cancelled, .ended:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translation(in: view).x / view.bounds.width
            let velocity = recognizer.velocity(in: view).x
            if progress > 0.33 || velocity > 1000 {
                finish()
            } else {
                if #available(iOS 10.0, *), let viewController = viewController {
                    navigationController?.viewControllers.append(viewController)
                    update(0)
                }
                cancel()

                if let viewController = viewController as? ZoomTransitionDestinationDelegate {
                    viewController.transitionDestinationDidCancel()
                }
                if let viewController = navigationController?.viewControllers.last as? ZoomTransitionSourceDelegate {
                    viewController.transitionSourceDidCancel()
                }
            }
            interactive = false
        default:
            break
        }
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ZoomInteractiveTransition: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isDestinationController: Bool = navigationController?.viewControllers.last is ZoomTransitionDestinationDelegate
        if gestureRecognizer === navigationController?.interactivePopGestureRecognizer {
            return !isDestinationController
        } else if gestureRecognizer === zoomPopGestureRecognizer {
            if isDestinationController {
                interactive = true
                if #available(iOS 10.0, *) {
                    viewController = navigationController?.popViewController(animated: true)
                }
                return true
            }
        }
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer === navigationController?.interactivePopGestureRecognizer
    }
}
