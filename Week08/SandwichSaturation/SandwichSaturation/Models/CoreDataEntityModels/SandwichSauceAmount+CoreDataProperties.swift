//
//  SandwichSauceAmount+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/19/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension SandwichSauceAmount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SandwichSauceAmount> {
        return NSFetchRequest<SandwichSauceAmount>(entityName: "SandwichSauceAmount")
    }

    @NSManaged public var amount: String
    @NSManaged public var id: UUID
    @NSManaged public var sandwiches: NSSet?

}

// MARK: Generated accessors for sandwiches
extension SandwichSauceAmount {

    @objc(addSandwichesObject:)
    @NSManaged public func addToSandwiches(_ value: Sandwich)

    @objc(removeSandwichesObject:)
    @NSManaged public func removeFromSandwiches(_ value: Sandwich)

    @objc(addSandwiches:)
    @NSManaged public func addToSandwiches(_ values: NSSet)

    @objc(removeSandwiches:)
    @NSManaged public func removeFromSandwiches(_ values: NSSet)

}
