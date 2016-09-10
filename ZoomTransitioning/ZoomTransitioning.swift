//
//  ZoomTransitioning.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomTransitioning: NSObject {

    static let transitionDuration: NSTimeInterval = 0.3
    private let source: ZoomTransitionSourceDelegate
    private let destination: ZoomTransitionDestinationDelegate
    private let forward: Bool

    required public init(source: ZoomTransitionSourceDelegate, destination: ZoomTransitionDestinationDelegate, forward: Bool) {
        self.source = source
        self.destination = destination
        self.forward = forward

        super.init()
    }
}


// MARK: -  UIViewControllerAnimatedTransitioning {

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return ZoomTransitioning.transitionDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }
}


// MARK: - Private

extension ZoomTransitioning {

    private func animateTransitionForPush(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            sourceView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            destinationView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }

        let transitioningImageView = transitioningPushImageView()

        containerView.backgroundColor = sourceView.backgroundColor
        sourceView.alpha = 1.0
        destinationView.alpha = 0.0

        containerView.insertSubview(destinationView, belowSubview: sourceView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()

        UIView.animateWithDuration(
            ZoomTransitioning.transitionDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                sourceView.alpha = 0.0
                destinationView.alpha = 1.0
                transitioningImageView.frame = self.destination.transitionDestinationImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                sourceView.alpha = 1.0
                transitioningImageView.alpha = 0.0
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd?()
                self.destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                let completed = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(completed)
        })
    }

    private func animateTransitionForPop(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            sourceView = transitionContext.viewForKey(UITransitionContextToViewKey),
            destinationView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }

        let transitioningImageView = transitioningPopImageView()

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
            ZoomTransitioning.transitionDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                destinationView.alpha = 0.0
                sourceView.alpha = 1.0
                transitioningImageView.frame = self.source.transitionSourceImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                destinationView.alpha = 1.0
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd?()
                self.destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                let completed: Bool
                if #available(iOS 10.0, *) {
                    completed = true
                } else {
                    completed = !transitionContext.transitionWasCancelled()
                }
                transitionContext.completeTransition(completed)
        })
    }

    private func transitioningPushImageView() -> UIImageView {
        let imageView = source.transitionSourceImageView()
        let frame = source.transitionSourceImageViewFrame(forward: forward)
        return UIImageView(baseImageView: imageView, frame: frame)
    }

    private func transitioningPopImageView() -> UIImageView {
        let imageView = source.transitionSourceImageView()
        let frame = destination.transitionDestinationImageViewFrame(forward: forward)
        return UIImageView(baseImageView: imageView, frame: frame)
    }
}
