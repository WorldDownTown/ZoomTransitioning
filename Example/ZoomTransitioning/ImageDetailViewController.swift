//
//  ImageDetailViewController.swift
//  ZoomTransitioning
//
//  Created by shoji on 2016/07/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var image: UIImage?

    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
