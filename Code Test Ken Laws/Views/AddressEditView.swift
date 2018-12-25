//
//  AddressEditView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/23/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

class AddressEditView: UIView {

	@IBOutlet weak var addressTypeField:BorderedTextField!
	@IBOutlet weak var addressTypeBottom: NSLayoutConstraint!
	@IBOutlet weak var streetField:BorderedTextField!
	@IBOutlet weak var streetBottom: NSLayoutConstraint!
	@IBOutlet weak var suiteField:BorderedTextField!
	@IBOutlet weak var suiteBottom: NSLayoutConstraint!
	@IBOutlet weak var cityField:BorderedTextField!
	@IBOutlet weak var cityWidth: NSLayoutConstraint!
	@IBOutlet weak var cityTrailing: NSLayoutConstraint!
	@IBOutlet weak var cityBottom: NSLayoutConstraint!
	@IBOutlet weak var stateField:BorderedTextField!
	@IBOutlet weak var stateTrailing: NSLayoutConstraint!
	@IBOutlet weak var zipField:BorderedTextField!
	@IBOutlet weak var zipTrailing: NSLayoutConstraint!
	var delegate:DetailSectionProtocol!

	var sourceAddress: Address! {
		didSet {
			guard self.addressTypeField != nil else { return }
			self.populateFields()
		}
	}

	var editMode: Bool = false {
		didSet {
			self.setupEditMode()
		}
	}


	func setupEditMode() {
		addressTypeField.isEditable = editMode
		streetField.isEditable = editMode
		suiteField.isEditable = editMode
		cityField.isEditable = editMode
		stateField.isEditable = editMode
		zipField.isEditable = editMode
		addressTypeBottom.constant = editMode ? 7 : -7
		streetBottom.constant = editMode ? 7 : -7
		suiteBottom.constant = editMode ? 7 : (suiteField.text == "" ? -suiteField.frame.height : -7)
		cityWidth.priority = editMode ? UILayoutPriority(999) : UILayoutPriority(1)
		zipTrailing.priority = editMode ? UILayoutPriority(999) : UILayoutPriority(1)
		cityTrailing.constant = editMode ? 10 : -5
		stateTrailing.constant = editMode ? 10 : -5
		cityBottom.constant = editMode ? 15 : 5
	}


	func populateFields() {
		guard let address = sourceAddress else {
			self.clearAll()
			return
		}
		addressTypeField.text = address.addressType
		streetField.text = address.street
		suiteField.text = address.suite
		cityField.text = address.city
		stateField.text = address.state
		zipField.text = address.zip
	}


	func clearAll() {
		addressTypeField.text = nil
		streetField.text = nil
		suiteField.text = nil
		cityField.text = nil
		stateField.text = nil
		zipField.text = nil
	}

}


extension AddressEditView:UITextViewDelegate {


	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		delegate.scrollToView(view: self)
		return true
	}


	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		let text = textView.text.autoTrim
		switch textView {
		case addressTypeField:
			self.sourceAddress.addressType = text
		case streetField:
			self.sourceAddress.street = text
		case suiteField:
			self.sourceAddress.suite = text
		case cityField:
			self.sourceAddress.city = text
		case stateField:
			self.sourceAddress.state = text
		case zipField:
			self.sourceAddress.zip = text
		default:
			break
		}
		self.delegate.updateDetailText()
		self.sourceAddress.person?.timestamp = NSDate()
		self.sourceAddress.managedObjectContext?.saveAndContinue()
		return true
	}


	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard text == "\n" else { return true }

		let fields = [addressTypeField, streetField, suiteField, cityField, stateField, zipField]
		if var idx = fields.firstIndex(of: textView as? BorderedTextField) {
			idx += 1
			if idx == fields.count {
				idx = 0
			}
			fields[idx]?.becomeFirstResponder()
		}

		return false
	}

}
