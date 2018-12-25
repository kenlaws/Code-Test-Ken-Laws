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
	@IBOutlet weak var actionBtn: UIButton!
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
		actionBtn.setImage(editMode ? #imageLiteral(resourceName: "delete"):#imageLiteral(resourceName: "phone"), for: .normal)
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


	@IBAction func handleActionBtn() {
		if editMode {
			Alert.withButtonsAndCompletion(title: "Delete?", msg: "Delete this phone number?", cancel: "Cancel", buttons: ["OK"]) { (idx) in
				if idx == 1 {
					self.delegate.removePhoneView(phoneView: self)
				}
			}
		} else {
			let phoneNumber = phoneNumberOnly()
			guard let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
				Alert.withOneButton(title: "Error", msg: "This phone number doesn't seem to be valid.", btn: "OK")
				return
			}
			UIApplication.shared.open(url)
		}
	}


	func phoneNumberOnly() -> String {
		let filtredUnicodeScalars = phoneNumberField.text.unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
		return String(String.UnicodeScalarView(filtredUnicodeScalars))
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
