//
//  ImageListViewController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class ImageListViewController: UICollectionViewController {
    private var selectedImageView: UIImageView?
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

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 8
        let columns: CGFloat = 2
        let length: CGFloat = (collectionView.frame.width - space * (columns + 1)) / columns
        return CGSize(width: length, height: length)
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension ImageListViewController: ZoomTransitionSourceDelegate {
    var animationDuration: TimeInterval {
        return 0.4
    }

    func transitionSourceImageView() -> UIImageView {
        return selectedImageView ?? UIImageView()
    }

    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        guard let selectedImageView = selectedImageView else { return .zero }
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

    // Uncomment method below if you customize the animation.
/*
    func zoomAnimation(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 2,
            options: .curveEaseInOut,
            animations: animations,
            completion: completion)
    }
 */
}
