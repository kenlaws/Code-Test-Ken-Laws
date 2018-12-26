//
//  String+Utilities.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit


public extension String {

	/// A quick shortcut to remove any whitespace chars from the start and end of a string.
	///
	/// - Returns: the String, stripped of leading and trailing whitespace
	var autoTrim: String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}
}
