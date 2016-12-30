//
//  ImageOnlyViewController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/13/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class ImageOnlyViewController: UIViewController {

    var image: UIImage?
    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
