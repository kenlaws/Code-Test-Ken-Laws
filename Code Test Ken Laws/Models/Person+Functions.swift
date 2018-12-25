//
//  Person+Functions.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/19/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

extension Person {

	func fullName() -> String {
		var fullName = ""
		if let firstName = self.firstName {
			fullName += firstName + " "
		}
		if let lastName = self.lastName {
			fullName += lastName
		}
		return fullName
	}

	
}
