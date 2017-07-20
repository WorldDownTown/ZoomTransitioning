//
//  ZoomTransitioning.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomTransitioning: NSObject {
    fileprivate let source: ZoomTransitionSourceDelegate
    fileprivate let destination: ZoomTransitionDestinationDelegate
    fileprivate let forward: Bool

    open func runAnimation(animations: @escaping () -> Swift.Void, completion: @escaping (() -> Swift.Void)) {
        if source.responds(to: #selector(ZoomTransitionSourceDelegate.zoomAnimation)) {
            source.zoomAnimation?(animations: animations, completion: completion)
        } else {
            UIView.animate(withDuration: source.zoomDuration?() ?? 0.3, delay: 0, options: .curveEaseInOut, animations: {
                animations()
            }) { _ in
                completion()
            }
        }
    }
    
    required public init(source: ZoomTransitionSourceDelegate, destination: ZoomTransitionDestinationDelegate, forward: Bool) {
        self.source = source
        self.destination = destination
        self.forward = forward

        super.init()
    }
}


// MARK: -  UIViewControllerAnimatedTransitioning {

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return source.zoomDuration?() ?? 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }

    private func animateTransitionForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        let containerView = transitionContext.containerView
        let transitioningImageView = transitioningPushImageView()

        containerView.backgroundColor = sourceView.backgroundColor
        sourceView.alpha = 1.0
        destinationView.alpha = 0.0

        containerView.insertSubview(destinationView, belowSubview: sourceView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin?(forward: self.forward)
        destination.transitionDestinationWillBegin?(forward: self.forward)

        self.runAnimation(animations: { 
            sourceView.alpha = 0.0
            destinationView.alpha = 1.0
            transitioningImageView.frame = self.destination.transitionDestinationImageViewFrame(forward: self.forward)
        }) {
            sourceView.alpha = 1.0
            transitioningImageView.alpha = 0.0
            transitioningImageView.removeFromSuperview()
            
            self.source.transitionSourceDidEnd?(forward: self.forward)
            self.destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)
            
            let completed = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(completed)
        }
    }

    private func animateTransitionForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        let containerView = transitionContext.containerView
        let transitioningImageView = transitioningPopImageView()

        containerView.backgroundColor = destinationView.backgroundColor
        destinationView.alpha = 1.0
        sourceView.alpha = 0.0

        containerView.insertSubview(sourceView, belowSubview: destinationView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin?(forward: self.forward)
        destination.transitionDestinationWillBegin?(forward: self.forward)

        if transitioningImageView.frame.maxY < 0.0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        
        self.runAnimation(animations: { 
            destinationView.alpha = 0.0
            sourceView.alpha = 1.0
            transitioningImageView.frame = self.source.transitionSourceImageViewFrame(forward: self.forward)
        }) {
            destinationView.alpha = 1.0
            transitioningImageView.removeFromSuperview()
            
            self.source.transitionSourceDidEnd?(forward: self.forward)
            self.destination.transitionDestinationDidEnd?(transitioningImageView: transitioningImageView)
            
            let completed: Bool
            if #available(iOS 10.0, *) {
                completed = true
            } else {
                completed = !transitionContext.transitionWasCancelled
            }
            transitionContext.completeTransition(completed)
        }
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
