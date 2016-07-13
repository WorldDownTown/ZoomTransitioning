//
//  ImageOnlyViewController.swift
//  ZoomTransitioning
//
//  Created by shoji on 2016/07/13.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class ImageOnlyViewController: UIViewController {

    var image: UIImage?
    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
