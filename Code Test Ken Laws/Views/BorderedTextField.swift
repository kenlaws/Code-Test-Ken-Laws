//
//  BorderedTextField.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedTextField: UITextView {

	@IBInspectable var borderWidth:CGFloat = 0.5

	@IBInspectable var borderColor:UIColor = UIColor.lightGray

	@IBInspectable var offBorderColor:UIColor = UIColor.clear

	@IBInspectable var cornerRadius:CGFloat = 4

	override var isEditable: Bool {
		didSet {
			self.setNeedsLayout()
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.masksToBounds = true
		layer.cornerRadius = cornerRadius
		layer.borderWidth = borderWidth
		layer.borderColor = isEditable ? borderColor.cgColor : offBorderColor.cgColor
	}

}
