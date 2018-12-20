//
//  Person+CoreDataProperties.swift
//  Code Test Ken Laws
//
//  Created by Ken Laws on 12/18/18.
//  Copyright © 2018 dela. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var addresses: NSOrderedSet?
    @NSManaged public var phones: NSOrderedSet?
    @NSManaged public var emails: NSOrderedSet?

}

// MARK: Generated accessors for addresses
extension Person {

    @objc(insertObject:inAddressesAtIndex:)
    @NSManaged public func insertIntoAddresses(_ value: Address, at idx: Int)

    @objc(removeObjectFromAddressesAtIndex:)
    @NSManaged public func removeFromAddresses(at idx: Int)

    @objc(insertAddresses:atIndexes:)
    @NSManaged public func insertIntoAddresses(_ values: [Address], at indexes: NSIndexSet)

    @objc(removeAddressesAtIndexes:)
    @NSManaged public func removeFromAddresses(at indexes: NSIndexSet)

    @objc(replaceObjectInAddressesAtIndex:withObject:)
    @NSManaged public func replaceAddresses(at idx: Int, with value: Address)

    @objc(replaceAddressesAtIndexes:withAddresses:)
    @NSManaged public func replaceAddresses(at indexes: NSIndexSet, with values: [Address])

    @objc(addAddressesObject:)
    @NSManaged public func addToAddresses(_ value: Address)

    @objc(removeAddressesObject:)
    @NSManaged public func removeFromAddresses(_ value: Address)

    @objc(addAddresses:)
    @NSManaged public func addToAddresses(_ values: NSOrderedSet)

    @objc(removeAddresses:)
    @NSManaged public func removeFromAddresses(_ values: NSOrderedSet)

}

// MARK: Generated accessors for phones
extension Person {

    @objc(insertObject:inPhonesAtIndex:)
    @NSManaged public func insertIntoPhones(_ value: Phone, at idx: Int)

    @objc(removeObjectFromPhonesAtIndex:)
    @NSManaged public func removeFromPhones(at idx: Int)

    @objc(insertPhones:atIndexes:)
    @NSManaged public func insertIntoPhones(_ values: [Phone], at indexes: NSIndexSet)

    @objc(removePhonesAtIndexes:)
    @NSManaged public func removeFromPhones(at indexes: NSIndexSet)

    @objc(replaceObjectInPhonesAtIndex:withObject:)
    @NSManaged public func replacePhones(at idx: Int, with value: Phone)

    @objc(replacePhonesAtIndexes:withPhones:)
    @NSManaged public func replacePhones(at indexes: NSIndexSet, with values: [Phone])

    @objc(addPhonesObject:)
    @NSManaged public func addToPhones(_ value: Phone)

    @objc(removePhonesObject:)
    @NSManaged public func removeFromPhones(_ value: Phone)

    @objc(addPhones:)
    @NSManaged public func addToPhones(_ values: NSOrderedSet)

    @objc(removePhones:)
    @NSManaged public func removeFromPhones(_ values: NSOrderedSet)

}

// MARK: Generated accessors for emails
extension Person {

    @objc(insertObject:inEmailsAtIndex:)
    @NSManaged public func insertIntoEmails(_ value: Email, at idx: Int)

    @objc(removeObjectFromEmailsAtIndex:)
    @NSManaged public func removeFromEmails(at idx: Int)

    @objc(insertEmails:atIndexes:)
    @NSManaged public func insertIntoEmails(_ values: [Email], at indexes: NSIndexSet)

    @objc(removeEmailsAtIndexes:)
    @NSManaged public func removeFromEmails(at indexes: NSIndexSet)

    @objc(replaceObjectInEmailsAtIndex:withObject:)
    @NSManaged public func replaceEmails(at idx: Int, with value: Email)

    @objc(replaceEmailsAtIndexes:withEmails:)
    @NSManaged public func replaceEmails(at indexes: NSIndexSet, with values: [Email])

    @objc(addEmailsObject:)
    @NSManaged public func addToEmails(_ value: Email)

    @objc(removeEmailsObject:)
    @NSManaged public func removeFromEmails(_ value: Email)

    @objc(addEmails:)
    @NSManaged public func addToEmails(_ values: NSOrderedSet)

    @objc(removeEmails:)
    @NSManaged public func removeFromEmails(_ values: NSOrderedSet)

}
