//
//  EmailSectionView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/20/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class EmailSectionView: UIStackView {

	var delegate:DetailSectionProtocol!

	/// Creates subviews for each existing address.
	///
	func populateEmails() {
		// Make certain we're starting fresh.
		for view in self.arrangedSubviews {
			self.removeArrangedSubview(view)
			view.removeFromSuperview()
		}

		guard let emails = delegate.targetPerson?.emails else {
			return
		}

		// Load any existing numbers.
		for email in emails {
			let newEmail = EmailEditView.fromNib()
			newEmail.delegate = delegate
			newEmail.sourceEmail = email as? Email
			self.addArrangedSubview(newEmail)
		}
	}


	/// Sets editing mode on or off for all subviews.
	///
	/// - Parameter toOn: Whether to turn editing on or off.
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
	}


	func removeEmail(emailView:EmailEditView) {
		guard let email = emailView.sourceEmail, let context = email.managedObjectContext else {
			return
		}
		self.removeArrangedSubview(emailView)
		context.delete(email)
		context.saveAndContinue()
		emailView.removeFromSuperview()
	}
}

