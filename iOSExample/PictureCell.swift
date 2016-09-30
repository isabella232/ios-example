//
//  PictureCell.swift
//  ApptentiveExample
//
//  Created by Frank Schmitt on 8/6/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var likeButton: UIButton!
	
	override func awakeFromNib() {
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOpacity = 1.0

		self.likeButton.layer.shadowColor = UIColor.black.cgColor
		self.likeButton.layer.shadowOpacity = 1.0
		self.likeButton.layer.shadowOffset = CGSize.zero

		super.awakeFromNib()
	}
}
