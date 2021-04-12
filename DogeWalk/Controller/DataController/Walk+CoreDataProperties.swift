//
//  Walk+CoreDataProperties.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.04.21.
//

import Foundation
import MapKit
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: String?
    @NSManaged public var distance: String?
    @NSManaged public var route: [CLLocation]?
    @NSManaged public var startTime: String?
    @NSManaged public var time: String?
    @NSManaged public var participatingDogs: NSSet?

}

// MARK: Generated accessors for participatingDogs
extension Walk {
    @objc(insertObject:inParticipatingDogsAtIndex:)
    @NSManaged public func insertIntoParticipatingDogs(_ value: Dog, at idx: Int)

    @objc(removeObjectFromParticipatingDogsAtIndex:)
    @NSManaged public func removeFromParticipatingDogs(at idx: Int)

    @objc(insertParticipatingDogs:atIndexes:)
    @NSManaged public func insertIntoParticipatingDogs(_ values: [Dog], at indexes: NSIndexSet)

    @objc(removeParticipatingDogsAtIndexes:)
    @NSManaged public func removeFromParticipatingDogs(at indexes: NSIndexSet)

    @objc(replaceObjectInParticipatingDogsAtIndex:withObject:)
    @NSManaged public func replaceParticipatingDogs(at idx: Int, with value: Dog)

    @objc(replaceParticipatingDogsAtIndexes:withParticipatedWalks:)
    @NSManaged public func replaceParticipatingDogs(at indexes: NSIndexSet, with values: [Dog])

    @objc(addParticipatingDogsObject:)
    @NSManaged public func addToParticipatingDogs(_ value: Dog)

    @objc(removeParticipatingDogsObject:)
    @NSManaged public func removeFromParticipatingDogs(_ value: Walk)

    @objc(addParticipatingDogs:)
    @NSManaged public func addToParticipatingDogs(_ values: NSOrderedSet)

    @objc(removeParticipatingDogs:)
    @NSManaged public func removeFromParticipatingDogs(_ values: NSOrderedSet)
}

extension Walk : Identifiable {

}
