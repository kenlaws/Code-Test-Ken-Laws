//
//  BorderedTextField.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

/// Custom UITextView class used by every editable text view.
/// Knows how to change from bordered to non-bordered (imitating a UILabel, in our case.)
///
@IBDesignable
class BorderedTextField: UITextView {

	@IBInspectable var borderWidth:CGFloat = 0.5

	@IBInspectable var borderColor:UIColor = UIColor.lightGray

	@IBInspectable var offBorderColor:UIColor = UIColor.clear

	@IBInspectable var cornerRadius:CGFloat = 4

	@IBInspectable var placeholderText:String = ""

	override var isEditable: Bool {
		didSet {
			self.setNeedsLayout()
		}
	}


	override func layoutSubviews() {
		super.layoutSubviews()

		if self.text == "" && isEditable && !isFirstResponder {
			self.textColor = UIColor.lightGray
			self.text = placeholderText
		}

		layer.masksToBounds = true
		layer.cornerRadius = cornerRadius
		layer.borderWidth = borderWidth
		layer.borderColor = isEditable ? borderColor.cgColor : offBorderColor.cgColor
	}

}


extension BorderedTextField {

	func handleBeginEditing() {
		if self.text == placeholderText {
			self.text = ""
		}
		self.textColor = UIColor.black
	}


	func handleEndEditing() {
		if self.text.autoTrim == "" {
			self.textColor = UIColor.lightGray
			self.text = placeholderText
		}
	}
}
