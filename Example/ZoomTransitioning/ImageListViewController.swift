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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        let vc = segue.destinationViewController as! ImageDetailViewController
        let index = collectionView?.indexPathsForSelectedItems()?.first?.item ?? 0
        vc.image = UIImage(named: "image\(index)")
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


// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let space: CGFloat = 8.0
        let length = (collectionView.frame.width - space * 3.0) / 2.0
        return CGSize(width: length, height: length)
    }
}
