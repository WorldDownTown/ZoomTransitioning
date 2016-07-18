//
//  UIImageView+extension.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

extension UIImageView {

    convenience init(baseImageView: UIImageView, frame: CGRect) {
        self.init(frame: CGRect.zero)

        image = baseImageView.image
        contentMode = baseImageView.contentMode
        clipsToBounds = true
        self.frame = frame
    }
}
