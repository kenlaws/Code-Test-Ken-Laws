//
//  String+Utilities.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

public class StringUtilities {
	public static let sharedInstance = StringUtilities()

	public let roundCurrencyFormatter = NumberFormatter()
	public let specificCurrencyFormatter = NumberFormatter()
	public let numberFormatter = NumberFormatter()


	init() {
		specificCurrencyFormatter.numberStyle = .currency
		specificCurrencyFormatter.locale = NSLocale.current

		roundCurrencyFormatter.numberStyle = .currency
		roundCurrencyFormatter.maximumFractionDigits = 0
		roundCurrencyFormatter.locale = NSLocale.current

		numberFormatter.numberStyle = .none
		numberFormatter.groupingSize = 3
		numberFormatter.usesGroupingSeparator = true
	}

}


public extension String {
	

	/// A quick shortcut to remove any whitespace chars from the start and end of a string.
	///
	/// - Returns: the String, stripped of leading and trailing whitespace
	var autoTrim: String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}


}
