//
//  ZoomTransitioning.swift
//  Pods
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomTransitioning: NSObject {

    static let transitionDuration: NSTimeInterval = 0.3
    weak var source: ZoomTransitionSourceDelegate?
    weak var destination: ZoomTransitionDestinationDelegate?
    private let forward: Bool

    required public init(source: ZoomTransitionSourceDelegate?, destination: ZoomTransitionDestinationDelegate, forward: Bool) {
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
            ZoomTransitioning.transitionDuration,
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
            ZoomTransitioning.transitionDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                destinationView.alpha = 0.0
                sourceView.alpha = 1.0
                transitioningImageView.frame = source.transitionSourceImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                destinationView.alpha = 1.0
                transitioningImageView.removeFromSuperview()

                source.transitionSourceDidEnd?()
                destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)

                let completed = !transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    private func transitioningPushImageView() -> UIImageView? {
        guard let imageView = source?.transitionSourceImageView(),
            frame = source?.transitionSourceImageViewFrame(forward: forward) else { return nil }
        return UIImageView(baseImageView: imageView, frame: frame)
    }

    private func transitioningPopImageView() -> UIImageView? {
        guard let imageView = source?.transitionSourceImageView(),
            frame = destination?.transitionDestinationImageViewFrame(forward: forward) else { return nil }
        return UIImageView(baseImageView: imageView, frame: frame)
    }
}
