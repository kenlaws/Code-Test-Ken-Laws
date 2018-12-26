//
//  PhoneSectionView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/19/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

/// Custom stack view for holding all current PhoneEditViews.
/// Knows how to add and delete Phones from CoreData.
///
@IBDesignable
class PhoneSectionView: UIStackView {

	var delegate:DetailSectionProtocol!

	func populatePhones() {
		// Make certain we're starting fresh.
		for view in self.arrangedSubviews {
			self.removeArrangedSubview(view)
			view.removeFromSuperview()
		}

		guard let phones = delegate.targetPerson?.phones else {
			return
		}

		// Load any existing numbers.
		for phone in phones {
			let newPhone = PhoneEditView.fromNib()
			newPhone.delegate = delegate
			newPhone.sourcePhone = phone as? Phone
			self.addArrangedSubview(newPhone)
		}
	}


	func setPhoneEditMode(toOn:Bool) {
		self.spacing = toOn ? 7 : 0
		for phone in self.arrangedSubviews as! [PhoneEditView] {
			phone.editMode = toOn
		}
	}


	func addNewPhone() {
		guard let context = delegate.context else { return }
		let newPhone = Phone(context: context)
		delegate.targetPerson?.insertIntoPhones(newPhone, at: 0)
		let newView = PhoneEditView.fromNib()
		newView.delegate = delegate
		newView.sourcePhone = newPhone
		self.insertArrangedSubview(newView, at: 0)
		newView.editMode = true
		newView.phoneTypeField.becomeFirstResponder()
	}


	func removePhone(phoneView:PhoneEditView) {
		guard let phone = phoneView.sourcePhone, let context = phone.managedObjectContext else {
			return
		}
		self.removeArrangedSubview(phoneView)
		context.delete(phone)
		context.saveAndContinue()
		phoneView.removeFromSuperview()
		delegate.targetPerson?.updateDetailText()
	}

}

