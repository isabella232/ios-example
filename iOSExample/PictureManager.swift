//
//  PictureSource.swift
//  ApptentiveExample
//
//  Created by Frank Schmitt on 8/6/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PictureManager {
	static let shared = PictureManager()
	
	var pictures = [Picture]()
	
	var favoriteDataSource: PictureDataSource
	var pictureDataSource: PictureDataSource
	
	init() {
		self.pictureDataSource = PictureDataSource(pictures: [])
		self.favoriteDataSource = PictureDataSource(pictures: [])

		Alamofire.request("https://unsplash.it/list").responseJSON { response in
			if let JSON = response.result.value as? [[String: Any]] {
				self.pictureDataSource.pictures = JSON[0...30].flatMap {
					Picture(json: $0)
				}
			}
		}

		self.pictureDataSource.manager = self
		self.favoriteDataSource.manager = self
	}

	fileprivate func indexOfFavorite(_ picture: Picture) -> Int? {
		return self.favoriteDataSource.pictures.index(of: picture)
	}
	
	func isFavorite(_ picture: Picture) -> Bool {
		return self.indexOfFavorite(picture) != nil
	}
	
	func addFavorite(_ picture: Picture) {
		if !self.isFavorite(picture) {
			self.favoriteDataSource.pictures.append(picture)
			self.favoriteDataSource.delegate?.pictureDataSourceDidUpdate(self.favoriteDataSource)
			self.pictureDataSource.delegate?.pictureDataSourceDidUpdate(self.favoriteDataSource)
		}
	}
	
	func removeFavorite(_ picture: Picture) {
		if let index = self.indexOfFavorite(picture) {
			self.favoriteDataSource.pictures.remove(at: index)
			self.favoriteDataSource.delegate?.pictureDataSourceDidUpdate(self.favoriteDataSource)
			self.pictureDataSource.delegate?.pictureDataSourceDidUpdate(self.favoriteDataSource)
		}
	}
}

protocol PictureDataSourceDelegate: class {
	func pictureDataSourceDidUpdate(_: PictureDataSource)
}

class PictureDataSource {
	var pictures: [Picture] {
		didSet {
			self.delegate?.pictureDataSourceDidUpdate(self)
		}
	}
	weak var manager: PictureManager?
	weak var delegate: PictureDataSourceDelegate?
	
	init(pictures: [Picture]) {
		self.pictures = pictures
	}
	
	func numberOfPictures() -> Int {
		return self.pictures.count
	}
	
	func imageURLAtIndex(_ index: Int, at size: CGSize) -> URL {
		let width = size.width * UIScreen.main.scale
		let height = size.height * UIScreen.main.scale

		return URL(string: "\(width)/\(height)?image=\(self.pictures[index].id)", relativeTo: URL(string: "https://unsplash.it/"))!
	}
	
	func imageAtIndex(_ index: Int) -> UIImage? {
		return self.pictures[index].image
	}
	
	func imageSizeAtIndex(_ index: Int) -> CGSize {
		return self.imageAtIndex(index)?.size ?? CGSize.zero
	}
	
	func imageNameAtIndex(_ index: Int) -> String {
		return pictures[index].filename ?? ""
	}
	
	func isLikedAtIndex(_ index: Int) -> Bool {
		return self.manager!.isFavorite(pictures[index])
	}
	
	func setLiked(_ index: Int, liked: Bool) {
		if liked && !self.isLikedAtIndex(index) {
			self.manager!.addFavorite(self.pictures[index])
		} else if !liked {
			self.manager!.removeFavorite(self.pictures[index])
		}
	}
}

extension Array {
	func shuffled() -> [Element] {
		if count < 2 {
			return self
		}
		
		var list = self
		for i in 0..<(list.count - 1) {
			let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
			if i != j {
				swap(&list[i], &list[j])
			}
		}
		return list
	}
}
