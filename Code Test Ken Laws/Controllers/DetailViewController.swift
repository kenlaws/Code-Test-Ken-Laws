//
//  DetailViewController.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol DetailSectionProtocol {
	var targetPerson:Person? { get }
	var context:NSManagedObjectContext? { get }
	var geoCoder:CLGeocoder? { get }
	func scrollToView(view: UIView)
	func removePhoneView(phoneView:PhoneEditView)
	func removeEmailView(emailView:EmailEditView)
	func removeAddressView(addressView:AddressEditView)
}


class DetailViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var firstNameField: BorderedTextField!
	@IBOutlet weak var firstNameBottom: NSLayoutConstraint!
	@IBOutlet weak var lastNameField: BorderedTextField!
	@IBOutlet weak var lastNameBottom: NSLayoutConstraint!
	@IBOutlet weak var birthdayField: BorderedTextField!
	@IBOutlet weak var birthdayBtn: UIButton!
	@IBOutlet weak var birthdayBottom: NSLayoutConstraint!
	@IBOutlet weak var addPhoneBtn: UIButton!
	@IBOutlet weak var phoneLabelBottom: NSLayoutConstraint!
	@IBOutlet weak var phoneFields: PhoneSectionView!
	@IBOutlet weak var addEmailBtn: UIButton!
	@IBOutlet weak var emailLabelBottom: NSLayoutConstraint!
	@IBOutlet weak var emailFields: EmailSectionView!
	@IBOutlet weak var addAddressBtn: UIButton!
	@IBOutlet weak var addressLabelBottom: NSLayoutConstraint!
	@IBOutlet weak var addressFields: AddressSectionView!
	@IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
	@IBOutlet weak var birthdayPicker: UIDatePicker!
	@IBOutlet weak var birthdayPickerBottom: NSLayoutConstraint!

	var managedObjectContext: NSManagedObjectContext = cdf.persistentContainer.viewContext
	var geocoder = CLGeocoder()

	var detailItem: Person? {
		didSet {
			guard let _ = firstNameField else { return }
			configureView()
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem
		phoneFields.delegate = self
		emailFields.delegate = self
		addressFields.delegate = self

		UIView.performWithoutAnimation {
			self.isEditing = false

			if let detail = self.detailItem, detail.firstName == nil, detail.lastName == nil {
				self.isEditing = true
			}

			self.birthdayPickerBottom.constant = -self.birthdayPicker.frame.height - self.view!.safeAreaInsets.bottom


			self.configureView()
			self.setupEditMode()
		}
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWillBeShown(notification:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)

		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWillBeShown(notification:)),
											   name: UIResponder.keyboardWillChangeFrameNotification,
											   object: nil)

		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWillBeHidden(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)

	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}


	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
			firstNameField.text = detail.firstName ?? ""
			lastNameField.text = detail.lastName ?? ""
			birthdayField.text = birthdateAsString()
			if let dob = detail.dateOfBirth as Date? {
				birthdayPicker.date = dob
			}
		} else {
			firstNameField.text = ""
			lastNameField.text = ""
			birthdayField.text = ""
		}
		self.updateNavTitle()
		phoneFields.populatePhones()
		emailFields.populateEmails()
		addressFields.populateAddresses()
	}


	func setupEditMode() {
		firstNameField.isEditable = isEditing
		firstNameBottom.constant = isEditing ? 8 : -8
		lastNameField.isEditable = isEditing
		lastNameBottom.constant = isEditing ? 8 : -8
		birthdayField.isEditable = isEditing
		birthdayBottom.constant = isEditing ? 30 : 10
		birthdayBtn.isEnabled = isEditing
		if !isEditing { hideBirthdayPicker() }
		addPhoneBtn.isHidden = !isEditing
		phoneLabelBottom.constant = isEditing ? 10 : 0
		phoneFields.setPhoneEditMode(toOn: isEditing)
		addEmailBtn.isHidden = !isEditing
		emailLabelBottom.constant = isEditing ? 10 : 0
		emailFields.setEmailEditMode(toOn: isEditing)
		addAddressBtn.isHidden = !isEditing
		addressLabelBottom.constant = isEditing ? 10 : 0
		addressFields.setAddressEditMode(toOn: isEditing)
	}


	func updateNavTitle() {
		guard let detail = detailItem else {
			self.navigationItem.title = "Details"
			return
		}
		self.navigationItem.title = detail.fullName()
	}


	override func setEditing(_ editing: Bool, animated: Bool) {
		guard detailItem != nil else {
			super.setEditing(false, animated: false)
			return
		}
		super.setEditing(editing, animated: animated)
		let anim = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
			self.setupEditMode()
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


	func birthdateAsString() -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		if let dob = detailItem?.dateOfBirth as Date? {
			return formatter.string(from: dob)
		} else {
			return ""
		}
	}


	@IBAction func handleBirthdayBtn() {
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
		if birthdayPickerBottom.constant < 0 {
			self.showBirthdayPicker()
		} else {
			self.hideBirthdayPicker()
		}

	}


	@IBAction func handleBirthdateChange(sender:UIDatePicker) {
		let newDate = sender.date
		detailItem?.dateOfBirth = newDate as NSDate
		managedObjectContext.saveAndContinue()
		birthdayField.text = birthdateAsString()
	}


	@IBAction func handleAddPhoneBtn() {
		phoneFields.addNewPhone()
	}


	@IBAction func handleAddEmailBtn() {
		emailFields.addNewEmail()
	}


	@IBAction func handleAddAddressBtn() {
		addressFields.addNewAddress()
	}


	func showBirthdayPicker() {
		birthdayPickerBottom.constant = 0
		let anim = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


	func hideBirthdayPicker() {
		birthdayPickerBottom.constant = -birthdayPicker.frame.height - self.view!.safeAreaInsets.bottom
		let anim = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


	@objc func keyboardWillBeShown(notification: Notification) {
		hideBirthdayPicker()
		let info = KLKeyboardParts(info: notification.userInfo)
		scrollViewBottom.constant = info.height - self.view!.safeAreaInsets.bottom
		let anim = UIViewPropertyAnimator(duration: info.rate, curve: .easeInOut) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


	@objc func keyboardWillBeHidden(notification: Notification) {
		let info = KLKeyboardParts(info: notification.userInfo)
		scrollViewBottom.constant = 0
		let anim = UIViewPropertyAnimator(duration: info.rate, curve: .easeInOut) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


}


extension DetailViewController: UITextViewDelegate {

	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		hideBirthdayPicker()
		return true
	}

	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		switch textView {
		case firstNameField:
			detailItem?.firstName = textView.text?.autoTrim
			self.updateNavTitle()
		case lastNameField:
			detailItem?.lastName = textView.text?.autoTrim
			self.updateNavTitle()
		default:
			break
		}
		managedObjectContext.saveAndContinue()
		return true
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard text == "\n" else { return true }

		switch textView {
		case firstNameField:
			lastNameField.becomeFirstResponder()
		case lastNameField:
			self.handleBirthdayBtn()
		default:
			break
		}

		return false
	}

}


extension DetailViewController: DetailSectionProtocol {
	var targetPerson:Person? {
		return self.detailItem
	}

	var context: NSManagedObjectContext? {
		return self.managedObjectContext
	}

	var geoCoder: CLGeocoder? {
		return self.geocoder
	}


	func scrollToView(view: UIView) {
		DispatchQueue.main.async {
			let rect = self.scrollView.convert(view.bounds, from: view).insetBy(dx: 0, dy: -10)
			self.scrollView.scrollRectToVisible(rect, animated: true)
		}
	}


	func removePhoneView(phoneView: PhoneEditView) {
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
		self.phoneFields.removePhone(phoneView: phoneView)
	}


	func removeEmailView(emailView: EmailEditView) {
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
		self.emailFields.removeEmail(emailView: emailView)
	}

	func removeAddressView(addressView: AddressEditView) {
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
		self.addressFields.removeAddress(addressView: addressView)
	}
}
