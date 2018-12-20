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

	@IBOutlet weak var phoneTypeField: UITextField!
	@IBOutlet weak var phoneNumberField: UITextField!

	var sourcePhone: Phone! {
		didSet {
			guard self.phoneTypeField != nil else { return }
			self.populateFields()
		}
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


extension PhoneEditView:UITextFieldDelegate {

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		switch textField {
		case phoneTypeField:
			self.sourcePhone.phoneType = textField.text?.autoTrim
		case phoneNumberField:
			self.sourcePhone.phoneNumber = textField.text?.autoTrim
		default:
			break
		}
		self.sourcePhone.person?.timestamp = NSDate()
		self.sourcePhone.managedObjectContext?.saveAndContinue()
		return true
	}

}
