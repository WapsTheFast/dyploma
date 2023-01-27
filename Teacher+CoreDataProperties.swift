//
//  Teacher+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.01.23.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var name: String?
    @NSManaged public var groups: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var lectures: Lecture?

}

// MARK: Generated accessors for groups
extension Teacher {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

extension Teacher : Identifiable {

}
