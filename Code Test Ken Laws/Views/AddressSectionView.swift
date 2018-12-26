//
//  AddressSectionView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/23/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class AddressSectionView: UIStackView {

	var delegate:DetailSectionProtocol!

	func populateAddresses() {
		// Make certain we're starting fresh.
		for view in self.arrangedSubviews {
			self.removeArrangedSubview(view)
			view.removeFromSuperview()
		}

		guard let addresses = delegate.targetPerson?.addresses else {
			return
		}

		// Load any existing numbers.
		for address in addresses {
			let newAddress = AddressEditView.fromNib()
			newAddress.delegate = delegate
			newAddress.sourceAddress = address as? Address
			self.addArrangedSubview(newAddress)
		}
	}


	func setAddressEditMode(toOn:Bool) {
		self.spacing = toOn ? 15 : 5
		for address in self.arrangedSubviews as! [AddressEditView] {
			address.editMode = toOn
		}
	}


	func addNewAddress() {
		guard let context = delegate.context else { return }
		let newAddress = Address(context: context)
		delegate.targetPerson?.insertIntoAddresses(newAddress, at: 0)
		let newView = AddressEditView.fromNib()
		newView.delegate = delegate
		newView.sourceAddress = newAddress
		self.insertArrangedSubview(newView, at: 0)
		newView.editMode = true
		newView.addressTypeField.becomeFirstResponder()
	}


	func removeAddress(addressView:AddressEditView) {
		guard let address = addressView.sourceAddress, let context = address.managedObjectContext else {
			return
		}
		self.removeArrangedSubview(addressView)
		context.delete(address)
		context.saveAndContinue()
		addressView.removeFromSuperview()
	}

}
