//
//  AddressEditView.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/23/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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
	@IBOutlet weak var actionBtn: UIButton!
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


	override func awakeFromNib() {
		super.awakeFromNib()
		streetField.textContainer.lineBreakMode = .byWordWrapping
		cityField.textContainer.lineBreakMode = .byWordWrapping
		zipField.textContainer.lineBreakMode = .byWordWrapping
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
		actionBtn.setImage(editMode ? #imageLiteral(resourceName: "delete"):#imageLiteral(resourceName: "map"), for: .normal)
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


	@IBAction func handleActionBtn() {
		if editMode {
			Alert.withButtonsAndCompletion(title: "Delete?", msg: "Delete this address?", cancel: "Cancel", buttons: ["OK"]) { (idx) in
				if idx == 1 {
					self.delegate.removeAddressView(addressView: self)
				}
			}
		} else {
			let locationString = "\(sourceAddress.street ?? "") \(sourceAddress.city ?? ""), \(sourceAddress.state ?? "") \(sourceAddress.zip ?? "")"
			delegate.geoCoder!.geocodeAddressString(locationString) { (places, err) in
				guard let placemark = places?.first, let loc = placemark.location else {
					Alert.withOneButton(title: "Error", msg: "We couldn't find this address.\n(\(err?.localizedDescription ?? "unknown error"))", btn: "OK")
					return
				}
				var pmName = self.sourceAddress.person!.fullName()
				if let aType = self.sourceAddress.addressType {
					pmName += " - \(aType)"
				}
				let destination = MKMapItem(placemark: MKPlacemark(location: loc, name: pmName, postalAddress: nil))
				destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
			}
		}
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
