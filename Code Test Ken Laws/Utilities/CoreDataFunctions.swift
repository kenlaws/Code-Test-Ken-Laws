//
//  CoreDataFunctions.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

let cdf = CoreDataFunctions.sharedInstance

/// This class handles the creation of the CoreData containers and variables.
///
class CoreDataFunctions {

	static let sharedInstance = CoreDataFunctions()

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Code_Test_Ken_Laws")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
		let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

		fetchRequest.fetchBatchSize = 20

		let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)

		fetchRequest.sortDescriptors = [sortDescriptor]

		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Master")

		do {
			try aFetchedResultsController.performFetch()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}

		return aFetchedResultsController
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			context.saveAndContinue()
		}
	}
}


/// This shorthands the save() function, removing the need for try
/// blocks throughout code where try blocks are really never needed.
///
extension NSManagedObjectContext {

	func saveAndContinue() {
		do {
			try self.save()
		} catch {
			let nserror = error as NSError
			print("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

}
