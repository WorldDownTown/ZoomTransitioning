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
    private weak var viewController: UIViewController?
    private var interactive = false

    var interactionController: ZoomInteractiveTransition? {
        return interactive ? self : nil
    }

    @objc func handlePanGestureRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .Changed:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translationInView(view).x / view.bounds.width
            updateInteractiveTransition(progress)
        case .Cancelled, .Ended:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translationInView(view).x / view.bounds.width
            let velocity = recognizer.velocityInView(view).x
            if progress > 0.33 || velocity > 1000.0 {
                finishInteractiveTransition()
            } else {
                if #available(iOS 10.0, *), let viewController = viewController {
                    navigationController?.viewControllers.append(viewController)
                    updateInteractiveTransition(0.0)
                }
                cancelInteractiveTransition()
            }
            interactive = false
        default:
            break
        }
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ZoomInteractiveTransition: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        interactive = true
        if #available(iOS 10.0, *) {
            viewController = navigationController?.popViewControllerAnimated(true)
        }
        return true
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
}
