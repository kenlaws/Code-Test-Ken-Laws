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
}


class DetailViewController: UIViewController {

	@IBOutlet weak var firstNameField: UITextField!
	@IBOutlet weak var lastNameField: UITextField!
	@IBOutlet weak var phoneFields: PhoneSectionView!

	var editMode:Bool = false

	var managedObjectContext: NSManagedObjectContext = cdf.persistentContainer.viewContext

	var detailItem: Person? {
		didSet {
			guard let _ = firstNameField else { return }
			configureView()
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		phoneFields.delegate = self

		configureView()
	}


	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
			firstNameField.text = detail.firstName ?? ""
			lastNameField.text = detail.lastName ?? ""
		}
		self.updateNavTitle()
		phoneFields.populatePhones()
	}


	func updateNavTitle() {
		guard let detail = detailItem else {
			self.navigationItem.title = "Details"
			return
		}
		self.navigationItem.title = detail.fullName()
	}


	@IBAction func handleEditBtn() {

	}


	@IBAction func handleAddPhoneBtn() {
		phoneFields.addNewPhone()
	}

}


extension DetailViewController: UITextFieldDelegate {

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		switch textField {
		case firstNameField:
			detailItem?.firstName = textField.text
			self.updateNavTitle()
		case lastNameField:
			detailItem?.lastName = textField.text
			self.updateNavTitle()
		default:
			break
		}
		managedObjectContext.saveAndContinue()
		return true
	}

}


extension DetailViewController: DetailSectionProtocol {
	var targetPerson:Person? {
		return self.detailItem
	}

	var context: NSManagedObjectContext? {
		return self.managedObjectContext
	}
}
