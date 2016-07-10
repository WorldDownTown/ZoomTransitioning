//
//  ImageListViewController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright (c) 2016 WorldDownTown. All rights reserved.
//

import UIKit
import ZoomTransitioning

class ImageListViewController: UICollectionViewController {

    private var selectedImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"
        clearsSelectionOnViewWillAppear = false
    }
}


// MARK: - UICollectionViewDataSource

extension ImageListViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ImageListCell), forIndexPath: indexPath) as! ImageListCell
        cell.imageView.image = UIImage(named: "image\(indexPath.item)")
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension ImageListViewController {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageListCell
        selectedImageView = cell.imageView
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let space: CGFloat = 8.0
        let length = (collectionView.frame.width - space * 3.0) / 2.0
        return CGSize(width: length, height: length)
    }
}


// MARK: - ZoomTransitionDelegate

extension ImageListViewController: ZoomTransitionDelegate {

    func transitionSourceImageView() -> UIImageView? {
        guard let selectedImageView = selectedImageView else { return nil }
        let imageView = UIImageView(image: selectedImageView.image)
        imageView.contentMode = selectedImageView.contentMode
        imageView.clipsToBounds = true
        imageView.frame = selectedImageViewFrame
        return imageView
    }

    func transitionSourceImageViewFrame() -> CGRect {
        return selectedImageViewFrame
    }

    func transitionDestinationImageViewFrame() -> CGRect {
        return selectedImageViewFrame
    }

    func transitionDidEnd(transitioningImageView imageView: UIImageView) {
    }

    private var selectedImageViewFrame: CGRect {
        guard let selectedImageView = selectedImageView else { return CGRect.zero }
        return selectedImageView.convertRect(selectedImageView.frame, toView: view)
    }
}
