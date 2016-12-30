//
//  ImageDetailViewController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class ImageDetailViewController: UIViewController {

    @IBOutlet fileprivate weak var largeImageView: UIImageView!
    @IBOutlet fileprivate weak var smallImageView1: UIImageView!
    @IBOutlet private weak var smallImageView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        smallImageView1.image = randomImage
        smallImageView2.image = randomImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let vc = segue.destination as? ImageOnlyViewController else { return }
        vc.image = smallImageView2.image
    }

    private var randomImage: UIImage {
        let num: Int = Int(arc4random() % 10)
        return UIImage(named: "image\(num)")!
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension ImageDetailViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return smallImageView1
    }

    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        return smallImageView1.convert(smallImageView1.bounds, to: view)
    }

    func transitionSourceWillBegin() {
        smallImageView1.isHidden = true
    }

    func transitionSourceDidEnd() {
        smallImageView1.isHidden = false
    }

    func transitionSourceDidCancel() {
        smallImageView1.isHidden = false
    }
}


// MARK: - ZoomTransitionDestinationDelegate

extension ImageDetailViewController: ZoomTransitionDestinationDelegate {

    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convert(largeImageView.bounds, to: view)
        }
    }

    func transitionDestinationWillBegin() {
        largeImageView.isHidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.isHidden = false
        largeImageView.image = imageView.image
    }

    func transitionDestinationDidCancel() {
        largeImageView.isHidden = false
    }
}
