//
//  EmailEditView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

class EmailEditView: UIView {

	@IBOutlet weak var emailTypeField: BorderedTextField!
	@IBOutlet weak var emailField: BorderedTextField!
	@IBOutlet weak var emailTypeTrailing: NSLayoutConstraint!
	var delegate:DetailSectionProtocol!

	var sourceEmail: Email! {
		didSet {
			guard self.emailTypeField != nil else { return }
			self.populateFields()
		}
	}

	var editMode: Bool = false {
		didSet {
			self.setupEditMode()
		}
	}


	func setupEditMode() {
		emailTypeField.isEditable = editMode
		emailField.isEditable = editMode
		emailTypeTrailing.constant = editMode ? 10 : -5
	}


	func populateFields() {
		guard let email = sourceEmail else {
			self.clearAll()
			return
		}
		emailTypeField.text = email.emailType
		emailField.text = email.emailAddress
	}


	func clearAll() {
		emailTypeField.text = nil
		emailField.text = nil
	}

}


extension EmailEditView:UITextViewDelegate {

	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		delegate.scrollToView(view: self)
		return true
	}


	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		switch textView {
		case emailTypeField:
			self.sourceEmail.emailType = textView.text.autoTrim
		case emailField:
			self.sourceEmail.emailAddress = textView.text.autoTrim
		default:
			break
		}
		self.delegate.updateDetailText()
		self.sourceEmail.person?.timestamp = NSDate()
		self.sourceEmail.managedObjectContext?.saveAndContinue()
		return true
	}


	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard text == "\n" else { return true }

		switch textView {
		case emailTypeField:
			emailField.becomeFirstResponder()
		case emailField:
			emailTypeField.becomeFirstResponder()
		default:
			break
		}

		return false
	}


}
