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

    @IBOutlet private weak var largeImageView: UIImageView!
    @IBOutlet private weak var smallImageView1: UIImageView!
    @IBOutlet private weak var smallImageView2: UIImageView!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        guard let vc = segue.destinationViewController as? ImageOnlyViewController else { return }
        vc.image = smallImageView2.image
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension ImageDetailViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return smallImageView1
    }

    func transitionSourceImageViewFrame(forward forward: Bool) -> CGRect {
        return smallImageView1.convertRect(smallImageView1.frame, toView: view)
    }

    func transitionSourceWillBegin() {
        smallImageView1.hidden = true
    }

    func transitionSourceDidEnd() {
        smallImageView1.hidden = false
    }

    func transitionSourceDidCancel() {
        smallImageView1.hidden = false
    }
}


// MARK: - ZoomTransitionDestinationDelegate

extension ImageDetailViewController: ZoomTransitionDestinationDelegate {

    func transitionDestinationImageViewFrame(forward forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convertRect(largeImageView.frame, toView: view)
        }
    }

    func transitionDestinationWillBegin() {
        largeImageView.hidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.hidden = false
        largeImageView.image = imageView.image
    }

    func transitionDestinationDidCancel() {
        largeImageView.hidden = false
    }
}
