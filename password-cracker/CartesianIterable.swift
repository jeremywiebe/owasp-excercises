//
//  CartesianIterable.swift
//  password-cracker
//
//  Created by Jeremy Wiebe on 2016-06-14.
//  Copyright © 2016 Jeremy Wiebe. All rights reserved.
//

import Foundation

class CartesianIterable: SequenceType {
	
	init(characters: [Character]) {
		self.characters = characters
	}
}