//
//  DataImport.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/25/18.
//  Copyright © 2018 dela. All rights reserved.
//

import UIKit
import CoreData

struct NameData: Codable {
	var first:String
	var last:String
	var birthday:String
	var email:String
}

struct PhoneData: Codable {
	var phone:String
}

struct AddressData: Codable {
	var street:String
	var city:String
	var state:String
	var zip:String
}



class DataImport {

	class func importNames() {
		let filePath = Bundle.main.url(forResource: "nameset", withExtension: "json")
		guard let rawNames = try? Data(contentsOf: filePath!) else { return }
		let decoder = JSONDecoder()
		guard let items = try? decoder.decode([NameData].self, from: rawNames) else { return }

		let phonePath = Bundle.main.url(forResource: "phoneset", withExtension: "json")
		guard let rawPhones = try? Data(contentsOf: phonePath!) else { return }
		guard let phones = try? decoder.decode([PhoneData].self, from: rawPhones) else { return }

		let addrPath = Bundle.main.url(forResource: "addressset", withExtension: "json")
		guard let rawAddr = try? Data(contentsOf: addrPath!) else { return }
		guard let addresses = try? decoder.decode([AddressData].self, from: rawAddr) else { return }

		let context = cdf.persistentContainer.viewContext

		context.performAndWait {
			let personDeleteFetch: NSFetchRequest<NSFetchRequestResult> = Person.fetchRequest()
			let personDeleteRequest = NSBatchDeleteRequest(fetchRequest: personDeleteFetch)
			try! context.execute(personDeleteRequest)
			try! context.save()
			let phoneTypes = ["iPhone", "mobile", "home", "work", "office"]
			for item in items {
				let newPerson = Person(context: context)
				newPerson.timestamp = NSDate()
				newPerson.firstName = item.first
				newPerson.lastName = item.last
				newPerson.dateOfBirth = NSDate(timeIntervalSinceReferenceDate: Double.random(in: -1600000000...(-270000000)))
				let newEmail = Email(context: context)
				newEmail.emailType = ["home", "work"].randomElement()
				newEmail.emailAddress = item.email
				newPerson.insertIntoEmails(newEmail, at: 0)

				if Int.random(in: 0...10) < 9 {
					let newPhone = Phone(context: context)
					newPhone.phoneType = phoneTypes.randomElement()
					newPhone.phoneNumber = phones.randomElement()?.phone
					newPerson.insertIntoPhones(newPhone, at: 0)
					if Int.random(in: 0...10) > 8 {
						let newPhone = Phone(context: context)
						newPhone.phoneType = phoneTypes.randomElement()
						newPhone.phoneNumber = phones.randomElement()?.phone
						newPerson.insertIntoPhones(newPhone, at: 0)
					}
				}

				if Int.random(in: 0...10) < 6 {
					let newAddress = Address(context: context)
					newAddress.addressType = ["home", "work"].randomElement()
					let rawAddress = addresses.randomElement()
					newAddress.street = rawAddress?.street
					newAddress.city = rawAddress?.city
					newAddress.state = rawAddress?.state
					newAddress.zip = rawAddress?.zip
					if Int.random(in: 0...10) < 3 {
						newAddress.suite = "Suite \(Int.random(in: 100...1000))"
					}
					newPerson.insertIntoAddresses(newAddress, at: 0)
				}

				newPerson.updateDetailText()
				try! context.save()
			}
		}
	}


}
