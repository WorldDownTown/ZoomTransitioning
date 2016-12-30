//
//  ImageListViewController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class ImageListViewController: UICollectionViewController {

    fileprivate var selectedImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"
        clearsSelectionOnViewWillAppear = false
    }
}


// MARK: - UICollectionViewDataSource

extension ImageListViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageListCell.self), for: indexPath) as! ImageListCell
        cell.imageView.image = UIImage(named: "image\(indexPath.item)")
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension ImageListViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageListCell
        selectedImageView = cell.imageView
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 8.0
        let length = (collectionView.frame.width - space * 3.0) / 2.0
        return CGSize(width: length, height: length)
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension ImageListViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return selectedImageView ?? UIImageView()
    }

    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        guard let selectedImageView = selectedImageView else { return CGRect.zero }
        return selectedImageView.convert(selectedImageView.bounds, to: view)
    }

    func transitionSourceWillBegin() {
        selectedImageView?.isHidden = true
    }

    func transitionSourceDidEnd() {
        selectedImageView?.isHidden = false
    }

    func transitionSourceDidCancel() {
        selectedImageView?.isHidden = false
    }
}
