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
    fileprivate weak var viewController: UIViewController?
    fileprivate var interactive = false

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
            if progress > 0.33 || velocity > 1000.0 {
                finish()
            } else {
                if #available(iOS 10.0, *), let viewController = viewController {
                    navigationController?.viewControllers.append(viewController)
                    update(0.0)
                }
                cancel()
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
        interactive = true
        if #available(iOS 10.0, *) {
            viewController = navigationController?.popViewController(animated: true)
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
}
