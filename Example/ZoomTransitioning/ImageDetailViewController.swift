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


// MARK: - ZoomTransitionDelegate

extension ImageDetailViewController: ZoomTransitionDelegate {

    func transitionSourceImageView() -> UIImageView? {
        let imageView = UIImageView(image: self.imageView.image)
        imageView.contentMode = self.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.frame = self.imageView.convertRect(self.imageView.frame, toView: view)
        return imageView
    }

    func transitionSourceImageViewFrame() -> CGRect {
        return imageView.convertRect(imageView.frame, toView: view)
    }

    func transitionDestinationImageViewFrame() -> CGRect {
        let x: CGFloat = 0.0
        let y = topLayoutGuide.length
        let width = view.frame.width
        let height = width * 2.0 / 3.0
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func transitionDidEnd(transitioningImageView imageView: UIImageView) {
        self.imageView.hidden = false
        self.imageView.image = imageView.image
    }
}
