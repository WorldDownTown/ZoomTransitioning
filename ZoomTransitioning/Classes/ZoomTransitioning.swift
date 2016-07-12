//
//  ZoomTransitioning.swift
//  Pods
//
//  Created by shoji on 2016/07/08.
//
//

import UIKit

@objc public protocol ZoomTransitionSourceDelegate: NSObjectProtocol {

    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame() -> CGRect
    optional func transitionSourceWillBegin()
    optional func transitionSourceDidEnd()
    optional func transitionSourceDidCancel()
}

@objc public protocol ZoomTransitionDestinationDelegate: NSObjectProtocol {

    func transitionDestinationImageViewFrame() -> CGRect
    optional func transitionDestinationWillBegin()
    optional func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
}

public class ZoomTransitioning: NSObject {

    private let screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    private let transitionDuration: NSTimeInterval = 0.3
    private weak var navigationController: UINavigationController?
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private weak var source: ZoomTransitionSourceDelegate?
    private weak var destination: ZoomTransitionDestinationDelegate?
    private var push = false
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
        self.navigationController = navigationController
        guard let source = fromVC as? ZoomTransitionSourceDelegate, let destination = toVC as? ZoomTransitionDestinationDelegate else { return nil }

        push = (operation == .Push)
        self.source = source
        self.destination = destination
        return self
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            source = source,
            destination = destination,
            sourceImageView = transitioningImageView() else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            return
        }

        containerView.backgroundColor = fromView.backgroundColor
        fromView.alpha = 1.0
        toView.alpha = 0.0

        containerView.insertSubview(toView, belowSubview: fromView)
        containerView.addSubview(sourceImageView)

        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()

        if push {
            UIView.animateWithDuration(
                transitionDuration,
                delay: 0.0,
                options: .CurveEaseOut,
                animations: {
                    fromView.alpha = 0.0
                    toView.alpha = 1.0
                    sourceImageView.frame = destination.transitionDestinationImageViewFrame()
                },
                completion: { _ in
                    fromView.alpha = 1.0
                    sourceImageView.alpha = 0.0
                    sourceImageView.removeFromSuperview()
                    toView.addGestureRecognizer(self.screenEdgePanGestureRecognizer)

                    source.transitionSourceDidEnd?()
                    destination.transitionDestinationDidEnd?(transitioningImageView: sourceImageView)

                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(completed)
            })
        } else {
            if sourceImageView.frame.maxY < 0.0 {
                sourceImageView.frame.origin.y = -sourceImageView.frame.height
            }
            UIView.animateWithDuration(
                transitionDuration,
                delay: 0.0,
                options: .CurveEaseOut,
                animations: {
                    fromView.alpha = 0.0
                    toView.alpha = 1.0
                    sourceImageView.frame = destination.transitionDestinationImageViewFrame()
                },
                completion: { _ in
                    fromView.alpha = 1.0
                    fromView.removeGestureRecognizer(self.screenEdgePanGestureRecognizer)
                    sourceImageView.removeFromSuperview()

                    source.transitionSourceDidEnd?()
                    destination.transitionDestinationDidEnd?(transitioningImageView: sourceImageView)

                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
}


// MARK: - UIViewControllerInteractiveTransitioning

extension ZoomTransitioning: UIViewControllerInteractiveTransitioning {

    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            containerView = transitionContext.containerView(),
            sourceImageView = transitioningImageView() else {
                return
        }

        self.transitionContext = transitionContext
        containerView.insertSubview(toView, belowSubview: fromView)
        containerView.addSubview(sourceImageView)
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

    private func transitioningImageView() -> UIImageView? {
        guard let sourceImageView = source?.transitionSourceImageView(),
            sourceImageViewFrame = source?.transitionSourceImageViewFrame() else { return nil }
        let imageView = UIImageView(image: sourceImageView.image)
        imageView.contentMode = sourceImageView.contentMode
        imageView.clipsToBounds = true
        imageView.frame = sourceImageViewFrame
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
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            sourceImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            destinationFrame = destination?.transitionDestinationImageViewFrame() else {
                return
        }
        guard var sourceFrame = source?.transitionSourceImageViewFrame() else { return }

        let rest = 1.0 - progress
        fromView.alpha = rest

        if sourceFrame.maxY < 0.0 {
            sourceFrame.origin.y = -sourceFrame.height
        }
        let x = destinationFrame.minX * progress + sourceFrame.minX * rest
        let y = destinationFrame.minY * progress + sourceFrame.minY * rest
        let width = destinationFrame.width * progress + sourceFrame.width * rest
        let height = destinationFrame.height * progress + sourceFrame.height * rest
        sourceImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        interactiveProgress = NSTimeInterval(progress)
        transitionContext.updateInteractiveTransition(progress)
    }

    private func finishInteractiveTransition() {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            sourceImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            destinationFrame = destination?.transitionDestinationImageViewFrame(),
            source = source,
            destination = destination else {
                return
        }

        let duration = transitionDuration * (1.0 - interactiveProgress)

        UIView.animateWithDuration(
            duration,
            animations: {
                fromView.alpha = 0.0
                sourceImageView.frame = destinationFrame
            },
            completion: { _ in
                sourceImageView.removeFromSuperview()
                sourceImageView.removeGestureRecognizer(self.screenEdgePanGestureRecognizer)

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: sourceImageView)

                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
        })
    }

    private func cancelInteractiveTransition() {
        guard let transitionContext = transitionContext,
            containerView = transitionContext.containerView(),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            sourceImageView = containerView.subviews.flatMap({ $0 as? UIImageView }).first,
            sourceFrame = source?.transitionSourceImageViewFrame(),
            source = source else {
                return
        }

        let duration = transitionDuration * interactiveProgress
        UIView.animateWithDuration(
            duration,
            animations: {
                fromView.alpha = 1.0
                sourceImageView.frame = sourceFrame
            },
            completion: { _ in
                sourceImageView.removeFromSuperview()

                source.transitionSourceDidCancel?()

                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
        })
    }
}
