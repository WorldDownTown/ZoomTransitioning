//
//  ImageDetailViewController.swift
//  ZoomTransitioning
//
//  Created by shoji on 2016/07/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import ZoomTransitioning

class ImageDetailViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
}


// MARK: - ZoomTransitionSourceDelegate

extension ImageDetailViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return imageView
    }

    func transitionSourceImageViewFrame() -> CGRect {
        return imageView.convertRect(imageView.frame, toView: view)
    }

    func transitionSourceWillBegin() {
        self.imageView.hidden = true
    }

    func transitionSourceDidEnd() {
        self.imageView.hidden = false
    }

    func transitionSourceDidCancel() {
        self.imageView.hidden = false
    }
}


// MARK: - ZoomTransitionDestinationDelegate

extension ImageDetailViewController: ZoomTransitionDestinationDelegate {

    func transitionDestinationImageViewFrame() -> CGRect {
        let x: CGFloat = 0.0
        let y = topLayoutGuide.length
        let width = view.frame.width
        let height = width * 2.0 / 3.0
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func transitionDestinationWillBegin() {
        self.imageView.hidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        self.imageView.hidden = false
        self.imageView.image = imageView.image
    }
}
