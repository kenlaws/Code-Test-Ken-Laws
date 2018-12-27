//
//  MasterViewController.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

/// The main view controller, first to appear on a phone, and appearing on the
/// left side on a pad. Contains the table view showing all the contacts.
///
class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	let managedObjectContext: NSManagedObjectContext = cdf.persistentContainer.viewContext
	let fetchedResultsController = cdf.fetchedResultsController

	override func viewDidLoad() {
		super.viewDidLoad()
		fetchedResultsController.delegate = self

		if fetchedResultsController.fetchedObjects?.count == 0 {
			print("Found zero entries. Populating with fake data...")
			DispatchQueue.global(qos: .background).async {
				DataImport.importNames()
			}
		}

		navigationItem.leftBarButtonItem = editButtonItem

		tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "PersonCell")

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		if Device == .pad, let section = fetchedResultsController.sections?[0], section.numberOfObjects > 0 {
			DispatchQueue.main.async {
				self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
				self.performSegue(withIdentifier: "showDetail", sender: nil)
			}
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


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			if let indexPath = tableView.indexPathForSelectedRow {
				let object = fetchedResultsController.object(at: indexPath)
				let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
				self.detailViewController = controller
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
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if Device == .pad {
				if detailViewController?.detailItem == fetchedResultsController.object(at: indexPath) {
					detailViewController?.detailItem = nil
				}
			}
		    let context = fetchedResultsController.managedObjectContext
		    context.delete(fetchedResultsController.object(at: indexPath))
			context.saveAndContinue()
		}
	}

	func configureCell(_ cell: PersonCell, withPerson person: Person) {
		cell.name.text = person.fullName()
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
			guard let cell = tableView.cellForRow(at: indexPath!) as? PersonCell else { return }
			configureCell(cell, withPerson: anObject as! Person)
		case .move:
			configureCell(tableView.cellForRow(at: indexPath!) as! PersonCell, withPerson: anObject as! Person)
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}


}
