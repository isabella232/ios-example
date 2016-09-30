//
//  PicturesViewController.swift
//  ApptentiveExample
//
//  Created by Frank Schmitt on 8/6/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

import UIKit
import QuickLook

class PicturesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PictureDataSourceDelegate {
	@IBOutlet var emptyLabel: UILabel!
	var imageSize = CGSize.zero
	let reuseIdentifier = "Picture"
	var manager: PictureManager! {
		didSet {
			self.configure()
			self.source.delegate = self
		}
	}
	
	var source: PictureDataSource!
	var minimumWidth: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()

		manager = PictureManager.shared

		self.collectionView!.backgroundView = self.emptyLabel

		self.updateEmpty(false)
	}

	func configure() {
		self.source = manager.pictureDataSource
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout, let collectionView = collectionView {
			let insetWidth = flowLayout.sectionInset.left + flowLayout.sectionInset.right

			let effectiveWidth = collectionView.bounds.width - insetWidth
			let spacing = flowLayout.minimumInteritemSpacing
			let columns = floor((effectiveWidth + spacing) / (self.minimumWidth + spacing))
			let size = ((effectiveWidth + spacing) / columns) - spacing

			imageSize = CGSize(width: size, height: size)
		}

		self.collectionViewLayout.invalidateLayout()
	}

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
	}

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.source.numberOfPictures() 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PictureCell

		cell.imageView.image = nil
		cell.imageView.af_setImage(withURL: self.source.imageURLAtIndex(indexPath.item, at: imageSize))
		cell.likeButton.tag = (indexPath as NSIndexPath).item
		cell.likeButton.isSelected = self.source.isLikedAtIndex(indexPath.item)
		
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return imageSize
	}

	// Picture Data Source Delegate
	func pictureDataSourceDidUpdate(_: PictureDataSource) {
		self.collectionView?.reloadSections(IndexSet(integer: 0))
		self.updateEmpty(true)
	}
		
	@IBAction func toggleLike(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		let index = sender.tag
		
		self.source?.setLiked(index, liked: sender.isSelected)
		
		self.collectionView!.reloadItems(at: [IndexPath(item: index, section: 0)])
	}

	func updateEmpty(_ animated: Bool) {
		let alpha: CGFloat = self.source.numberOfPictures() == 0 ? 1.0 : 0.0
		let duration = animated ? 0.1 : 0.0

		UIView.animate(withDuration: duration) { () -> Void in
			self.emptyLabel.alpha = alpha
		}
	}
}

