//
//  ZoomInteractiveTransitioning.swift
//  Pods
//
//  Created by shoji on 7/16/16.
//
//

import UIKit

final class ZoomInteractiveTransitioning: NSObject {

    private weak var source: ZoomTransitionSourceDelegate?
    private weak var destination: ZoomTransitionDestinationDelegate?
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private var interactive = false
    private var interactiveProgress: NSTimeInterval = 0.0
}


// MARK: - UIViewControllerInteractiveTransitioning

extension ZoomInteractiveTransitioning: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            sourceView = transitionContext.viewForKey(UITransitionContextToViewKey),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = transitioningPopImageView() else {
                return
        }

        self.transitionContext = transitionContext
        containerView.insertSubview(sourceView, belowSubview: destinationView)
        containerView.addSubview(transitioningImageView)
    }

    func completionCurve() -> UIViewAnimationCurve {
        return .EaseOut
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ZoomInteractiveTransitioning: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        interactive = true
        return true
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
}


// MARK: -

extension ZoomInteractiveTransitioning {

    private func transitioningPopImageView() -> UIImageView? {
        guard let imageView = source?.transitionSourceImageView(),
            frame = destination?.transitionDestinationImageViewFrame(forward: false) else {
                return nil
        }
        return UIImageView(baseImageView: imageView, frame: frame)
    }

    func interactionControllerForAnimationController(animationController: UIViewControllerAnimatedTransitioning) -> Self? {
        guard let zoomTransitioning = animationController as? ZoomTransitioning where interactive else { return nil }
        source = zoomTransitioning.source
        destination = zoomTransitioning.destination
        return self
    }

    @objc func handlePanGestureRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            beginInteractiveTransaction()
        case .Changed:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translationInView(view).x / view.bounds.width
            updateInteractiveTransitionWithProgress(progress)
        case .Cancelled, .Ended:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translationInView(view).x / view.bounds.width
            if progress > 0.33 {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
            interactive = false
        default:
            cancelInteractiveTransition()
            interactive = false
        }
    }

    private func beginInteractiveTransaction() {
        guard let source = source, destination = destination else { return }
        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()
    }

    private func updateInteractiveTransitionWithProgress(progress: CGFloat) {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            sourceFrame = source?.transitionSourceImageViewFrame(forward: false) else {
                return
        }
        guard var destinationFrame = destination?.transitionDestinationImageViewFrame(forward: false) else { return }

        let rest = 1.0 - progress
        destinationView.alpha = rest

        if destinationFrame.maxY < 0.0 {
            destinationFrame.origin.y = -destinationFrame.height
        }
        let x = sourceFrame.minX * progress + destinationFrame.minX * rest
        let y = sourceFrame.minY * progress + destinationFrame.minY * rest
        let width = sourceFrame.width * progress + destinationFrame.width * rest
        let height = sourceFrame.height * progress + destinationFrame.height * rest
        transitioningImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        interactiveProgress = NSTimeInterval(progress)
        transitionContext.updateInteractiveTransition(progress)
    }

    private func finishInteractiveTransition() {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            sourceFrame = source?.transitionSourceImageViewFrame(forward: false),
            source = source,
            destination = destination else {
                return
        }

        let duration = ZoomTransitioning.transitionDuration * (1.0 - interactiveProgress)
        UIView.animateWithDuration(
            duration,
            animations: {
                destinationView.alpha = 0.0
                transitioningImageView.frame = sourceFrame
            },
            completion: { _ in
                transitioningImageView.removeFromSuperview()

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
                self.transitionContext = nil
        })
    }

    private func cancelInteractiveTransition() {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            destinationFrame = destination?.transitionDestinationImageViewFrame(forward: false),
            source = source,
            destination = destination else {
                return
        }

        let duration = ZoomTransitioning.transitionDuration * interactiveProgress
        UIView.animateWithDuration(
            duration,
            animations: {
                destinationView.alpha = 1.0
                transitioningImageView.frame = destinationFrame
            },
            completion: { _ in
                transitioningImageView.removeFromSuperview()

                source.transitionSourceDidCancel?()
                destination.transitionDestinationDidCancel?()

                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
                self.transitionContext = nil
        })
    }
}
