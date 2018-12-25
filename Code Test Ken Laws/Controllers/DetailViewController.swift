//
//  DetailViewController.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

protocol DetailSectionProtocol {
	var targetPerson:Person? { get }
	var context:NSManagedObjectContext? { get }
	func updateDetailText()
	func scrollToView(view: UIView)
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
	@IBOutlet weak var phoneFields: PhoneSectionView!
	@IBOutlet weak var addEmailBtn: UIButton!
	@IBOutlet weak var emailFields: EmailSectionView!
	@IBOutlet weak var addAddressBtn: UIButton!
	@IBOutlet weak var addressFields: AddressSectionView!
	@IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
	@IBOutlet weak var birthdayPicker: UIDatePicker!
	@IBOutlet weak var birthdayPickerBottom: NSLayoutConstraint!

	var managedObjectContext: NSManagedObjectContext = cdf.persistentContainer.viewContext

	var detailItem: Person? {
		didSet {
			guard let _ = firstNameField else { return }
			configureView()
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem

		self.isEditing = false

		if let detail = detailItem, detail.firstName == nil, detail.lastName == nil {
			self.isEditing = true
		}

		birthdayPickerBottom.constant = -birthdayPicker.frame.height - self.view!.safeAreaInsets.bottom

		phoneFields.delegate = self
		emailFields.delegate = self
		addressFields.delegate = self

		configureView()
		setupEditMode()
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
		phoneFields.setPhoneEditMode(toOn: isEditing)
		addEmailBtn.isHidden = !isEditing
		emailFields.setEmailEditMode(toOn: isEditing)
		addAddressBtn.isHidden = !isEditing
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


	func updateDetailText() {
		var detailText = ""
		if let phones = detailItem?.phones?.array as? [Phone], phones.count > 0 {
			let usefulPhoneTypes = ["iPhone", "mobile", "home", "work", "office"]
			for type in usefulPhoneTypes {
				if let foundPhone = phones.first(where: { $0.phoneType == type && $0.phoneNumber != nil }) {
					detailText = "\(foundPhone.phoneNumber!) - \(foundPhone.phoneType!)"
					break
				}
			}
		}
		if detailText == "" {
			if let emails = detailItem?.emails?.array as? [Email], emails.count > 0 {
				let usefulEmailTypes = ["home", "office", "work"]
				for type in usefulEmailTypes {
					if let foundEmail = emails.first(where: { $0.emailType == type && $0.emailAddress != nil }) {
						detailText = "\(foundEmail.emailAddress!) - \(foundEmail.emailType!)"
						break
					}
				}
			}
		}
		detailItem?.detailText = detailText
		detailItem?.managedObjectContext?.saveAndContinue()
	}


	func scrollToView(view: UIView) {
		DispatchQueue.main.async {
			let rect = self.scrollView.convert(view.bounds, from: view).insetBy(dx: 0, dy: -10)
			self.scrollView.scrollRectToVisible(rect, animated: true)
		}
	}
}
