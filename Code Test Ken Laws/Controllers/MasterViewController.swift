//
//  MasterViewController.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import CoreLocation
import Intents

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext = cdf.persistentContainer.viewContext
	var fetchedResultsController = cdf.fetchedResultsController

	override func viewDidLoad() {
		super.viewDidLoad()
		fetchedResultsController.delegate = self

		navigationItem.leftBarButtonItem = editButtonItem

		tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "PersonCell")

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	@objc
	func insertNewObject(_ sender: Any) {
		let context = self.fetchedResultsController.managedObjectContext
		let newPerson = Person(context: context)
		     
		// If appropriate, configure the new managed object.
		newPerson.timestamp = Date() as NSDate

		// Save the context.
		context.saveAndContinue()
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
		self.performSegue(withIdentifier: "showDetail", sender: nil)
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			if let indexPath = tableView.indexPathForSelectedRow {
				let object = fetchedResultsController.object(at: indexPath)
				let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}

}

extension MasterViewController { //tableView functions

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
		let person = fetchedResultsController.object(at: indexPath)
		configureCell(cell, withPerson: person)
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		    let context = fetchedResultsController.managedObjectContext
		    context.delete(fetchedResultsController.object(at: indexPath))
			context.saveAndContinue()
		}
	}

	func configureCell(_ cell: PersonCell, withPerson person: Person) {
		cell.name.text = "\(person.firstName ?? "") \(person.lastName ?? "")"
		cell.detail.text = person.detailText ?? " "
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "showDetail", sender: nil)
	}

}


extension MasterViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			configureCell(tableView.cellForRow(at: indexPath!) as! PersonCell, withPerson: anObject as! Person)
		case .move:
			configureCell(tableView.cellForRow(at: indexPath!) as! PersonCell, withPerson: anObject as! Person)
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}


}
