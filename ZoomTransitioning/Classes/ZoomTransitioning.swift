//
//  ZoomTransitioning.swift
//  Pods
//
//  Created by shoji on 2016/07/08.
//
//

import UIKit

public class ZoomTransitioning: NSObject {

    private let screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    private let transitionDuration: NSTimeInterval = 0.3
    private weak var navigationController: UINavigationController?
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private weak var source: ZoomTransitionSourceDelegate?
    private weak var destination: ZoomTransitionDestinationDelegate?
    private var forward = false
    private var interactive = false
    private var interactiveProgress: NSTimeInterval = 0.0

    public required override init() {
        super.init()

        screenEdgePanGestureRecognizer.edges = .Left
        screenEdgePanGestureRecognizer.delegate = self
        screenEdgePanGestureRecognizer.addTarget(self, action: #selector(ZoomTransitioning.handlePanGestureRecognizer(_:)))
    }
}


// MARK: - UINavigationControllerDelegate

extension ZoomTransitioning: UINavigationControllerDelegate {

    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }

    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            guard let source = fromVC as? ZoomTransitionSourceDelegate, destination = toVC as? ZoomTransitionDestinationDelegate else { return nil }
            forward = true
            self.source = source
            self.destination = destination
        } else {
            guard let source = toVC as? ZoomTransitionSourceDelegate, destination = fromVC as? ZoomTransitionDestinationDelegate else { return nil }
            forward = false
            self.source = source
            self.destination = destination
        }

        self.navigationController = navigationController

        return self
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }

    private func animateTransitionForPush(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            sourceView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            destinationView = transitionContext.viewForKey(UITransitionContextToViewKey),
            source = source,
            destination = destination,
            transitioningImageView = transitioningPushImageView() else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }

        containerView.backgroundColor = sourceView.backgroundColor
        sourceView.alpha = 1.0
        destinationView.alpha = 0.0

        containerView.insertSubview(destinationView, belowSubview: sourceView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()

        UIView.animateWithDuration(
            transitionDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                sourceView.alpha = 0.0
                destinationView.alpha = 1.0
                transitioningImageView.frame = destination.transitionDestinationImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                sourceView.alpha = 1.0
                transitioningImageView.alpha = 0.0
                transitioningImageView.removeFromSuperview()
                destinationView.addGestureRecognizer(self.screenEdgePanGestureRecognizer)

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                let completed = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(completed)
        })
    }

    private func animateTransitionForPop(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            sourceView = transitionContext.viewForKey(UITransitionContextToViewKey),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            source = source,
            destination = destination,
            transitioningImageView = transitioningPopImageView() else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }

        containerView.backgroundColor = destinationView.backgroundColor
        destinationView.alpha = 1.0
        sourceView.alpha = 0.0

        containerView.insertSubview(sourceView, belowSubview: destinationView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()

        if transitioningImageView.frame.maxY < 0.0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        UIView.animateWithDuration(
            transitionDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                destinationView.alpha = 0.0
                sourceView.alpha = 1.0
                transitioningImageView.frame = source.transitionSourceImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                destinationView.alpha = 1.0
                destinationView.removeGestureRecognizer(self.screenEdgePanGestureRecognizer)
                transitioningImageView.removeFromSuperview()

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                let completed = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}


// MARK: - UIViewControllerInteractiveTransitioning

extension ZoomTransitioning: UIViewControllerInteractiveTransitioning {

    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            sourceView = transitionContext.viewForKey(UITransitionContextToViewKey),
            containerView = transitionContext.containerView(),
            transitioningImageView = transitioningPopImageView() else {
                return
        }

        self.transitionContext = transitionContext
        containerView.insertSubview(sourceView, belowSubview: destinationView)
        containerView.addSubview(transitioningImageView)
    }

    public func completionCurve() -> UIViewAnimationCurve {
        return .EaseOut
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ZoomTransitioning: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        interactive = true
        return true
    }
}


// MARK: - Private

extension ZoomTransitioning {

    private func transitioningPushImageView() -> UIImageView? {
        guard let transitioningImageView = source?.transitionSourceImageView(),
            transitioningImageViewFrame = source?.transitionSourceImageViewFrame(forward: forward) else { return nil }
        let imageView = UIImageView(image: transitioningImageView.image)
        imageView.contentMode = transitioningImageView.contentMode
        imageView.clipsToBounds = true
        imageView.frame = transitioningImageViewFrame
        return imageView
    }

    private func transitioningPopImageView() -> UIImageView? {
        guard let transitioningImageView = source?.transitionSourceImageView(),
            transitioningImageViewFrame = destination?.transitionDestinationImageViewFrame(forward: forward) else { return nil }
        let imageView = UIImageView(image: transitioningImageView.image)
        imageView.contentMode = transitioningImageView.contentMode
        imageView.clipsToBounds = true
        imageView.frame = transitioningImageViewFrame
        return imageView
    }

    @objc private func handlePanGestureRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
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
        guard let source = source, destination = destination, navigationController = navigationController else { return }

        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()
        navigationController.popViewControllerAnimated(true)
    }

    private func updateInteractiveTransitionWithProgress(progress: CGFloat) {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            sourceFrame = source?.transitionSourceImageViewFrame(forward: forward) else {
                return
        }
        guard var destinationFrame = destination?.transitionDestinationImageViewFrame(forward: forward) else { return }

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
            sourceFrame = source?.transitionSourceImageViewFrame(forward: forward),
            source = source,
            destination = destination else {
                return
        }

        let duration = transitionDuration * (1.0 - interactiveProgress)

        UIView.animateWithDuration(
            duration,
            animations: {
                destinationView.alpha = 0.0
                transitioningImageView.frame = sourceFrame
            },
            completion: { _ in
                transitioningImageView.removeFromSuperview()
                transitioningImageView.removeGestureRecognizer(self.screenEdgePanGestureRecognizer)

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
        })
    }

    private func cancelInteractiveTransition() {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            transitioningImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            destinationFrame = destination?.transitionDestinationImageViewFrame(forward: forward),
            source = source,
            destination = destination else {
                return
        }

        let duration = transitionDuration * interactiveProgress
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
        })
    }
}
