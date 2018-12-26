//
//  Person+Functions.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/19/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit

/// An extension of Person with functions to return a record's full name
/// and to determine which field to display under the name on the main view.
///
extension Person {

	func fullName() -> String {
		var fullName = ""
		if let firstName = self.firstName {
			fullName += firstName + " "
		}
		if let lastName = self.lastName {
			fullName += lastName
		}
		return fullName
	}


	func updateDetailText() {
		var detailText = " "
		if let phones = self.phones?.array as? [Phone], phones.count > 0 {
			let usefulPhoneTypes = ["iPhone", "mobile", "home", "work", "office"]
			for type in usefulPhoneTypes {
				if let foundPhone = phones.first(where: { $0.phoneType == type && $0.phoneNumber != nil }) {
					detailText = "\(foundPhone.phoneNumber!) - \(foundPhone.phoneType!)"
					break
				}
			}
		}
		if detailText == " " {
			if let emails = self.emails?.array as? [Email], emails.count > 0 {
				let usefulEmailTypes = ["home", "office", "work"]
				for type in usefulEmailTypes {
					if let foundEmail = emails.first(where: { $0.emailType == type && $0.emailAddress != nil }) {
						detailText = "\(foundEmail.emailAddress!) - \(foundEmail.emailType!)"
						break
					}
				}
			}
		}
		self.detailText = detailText
		self.managedObjectContext?.saveAndContinue()
	}

}


