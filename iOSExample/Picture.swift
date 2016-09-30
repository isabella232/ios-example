//
//  Picture.swift
//  ApptentiveExample
//
//  Created by Frank Schmitt on 8/6/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

import UIKit

class Picture: NSObject {
	let postURL: URL
	let author: String?
	let authorURL: URL?
	let filename: String?
	let format: String?
	let size: CGSize?
	let id: Int
	var image: UIImage? = nil

	init?(json: [String: Any]) {
		guard let postURLString = json["post_url"] as? String,
			let postURL = URL(string: postURLString),
			let id = json["id"] as? Int
		else {
			return nil;
		}

		self.postURL = postURL
		self.id = id

		self.author = json["author"] as? String

		if let authorURLString = json["author_url"] as? String, let authorURL = URL(string: authorURLString) {
			self.authorURL = authorURL
		} else {
			self.authorURL = nil
		}

		self.filename = json["filename"] as? String

		if let width = json["width"] as? CGFloat, let height = json["height"] as? CGFloat {
			self.size = CGSize(width: width, height: height)
		} else {
			self.size = nil
		}

		self.format = json["format"] as? String
	}
}
