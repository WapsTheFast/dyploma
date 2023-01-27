//
//  Student+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.01.23.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var group: Group?
    @NSManaged public var user: User?
    @NSManaged public var lectures: NSSet?

}

// MARK: Generated accessors for lectures
extension Student {

    @objc(addLecturesObject:)
    @NSManaged public func addToLectures(_ value: Lecture)

    @objc(removeLecturesObject:)
    @NSManaged public func removeFromLectures(_ value: Lecture)

    @objc(addLectures:)
    @NSManaged public func addToLectures(_ values: NSSet)

    @objc(removeLectures:)
    @NSManaged public func removeFromLectures(_ values: NSSet)

}

extension Student : Identifiable {

}
