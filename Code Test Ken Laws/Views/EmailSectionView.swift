//
//  EmailSectionView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

/// Custom stack view for holding any emailEditViews.
/// Knows how to add and remove Emails from CoreData.
///
@IBDesignable
class EmailSectionView: UIStackView {

	var delegate:DetailSectionProtocol!

	func populateEmails() {
		// Make certain we're starting fresh.
		for view in self.arrangedSubviews {
			self.removeArrangedSubview(view)
			view.removeFromSuperview()
		}

		guard let emails = delegate.targetPerson?.emails else {
			return
		}

		for email in emails {
			let newEmail = EmailEditView.fromNib()
			newEmail.delegate = delegate
			newEmail.sourceEmail = email as? Email
			self.addArrangedSubview(newEmail)
		}
	}


	func setEmailEditMode(toOn:Bool) {
		self.spacing = toOn ? 7 : 0
		for email in self.arrangedSubviews as! [EmailEditView] {
			email.editMode = toOn
		}
	}


	func addNewEmail() {
		guard let context = delegate.context else { return }
		let newEmail = Email(context: context)
		delegate.targetPerson?.insertIntoEmails(newEmail, at: 0)
		let newView = EmailEditView.fromNib()
		newView.delegate = delegate
		newView.sourceEmail = newEmail
		self.insertArrangedSubview(newView, at: 0)
		newView.editMode = true
		newView.emailTypeField.becomeFirstResponder()
	}


	func removeEmail(emailView:EmailEditView) {
		guard let email = emailView.sourceEmail, let context = email.managedObjectContext else {
			return
		}
		self.removeArrangedSubview(emailView)
		context.delete(email)
		context.saveAndContinue()
		emailView.removeFromSuperview()
		delegate.targetPerson?.updateDetailText()
	}
}

