//
//  PhoneEditView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

class PhoneEditView: UIView {

	@IBOutlet weak var phoneTypeField: BorderedTextField!
	@IBOutlet weak var phoneNumberField: BorderedTextField!
	@IBOutlet weak var phoneTypeTrailing: NSLayoutConstraint!
	var delegate:DetailSectionProtocol!

	var sourcePhone: Phone! {
		didSet {
			guard self.phoneTypeField != nil else { return }
			self.populateFields()
		}
	}

	var editMode: Bool = false {
		didSet {
			self.setupEditMode()
		}
	}


	func setupEditMode() {
		phoneTypeField.isEditable = editMode
		phoneNumberField.isEditable = editMode
		phoneTypeTrailing.constant = editMode ? 10 : -5
	}


	func populateFields() {
		guard let phone = sourcePhone else {
			self.clearAll()
			return
		}
		phoneTypeField.text = phone.phoneType
		phoneNumberField.text = phone.phoneNumber
	}


	func clearAll() {
		phoneTypeField.text = nil
		phoneNumberField.text = nil
	}

}


extension PhoneEditView:UITextViewDelegate {

	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		delegate.scrollToView(view: self)
		return true
	}


	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		switch textView {
		case phoneTypeField:
			self.sourcePhone.phoneType = textView.text?.autoTrim
		case phoneNumberField:
			self.sourcePhone.phoneNumber = textView.text?.autoTrim
		default:
			break
		}
		self.delegate.updateDetailText()
		self.sourcePhone.person?.timestamp = NSDate()
		self.sourcePhone.managedObjectContext?.saveAndContinue()
		return true
	}


	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard text == "\n" else { return true }

		switch textView {
		case phoneTypeField:
			phoneNumberField.becomeFirstResponder()
		case phoneNumberField:
			phoneTypeField.becomeFirstResponder()
		default:
			break
		}

		return false
	}

}
