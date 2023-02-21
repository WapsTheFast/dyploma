//
//  Lecture+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 16.02.23.
//
//

import Foundation
import CoreData


extension Lecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var matherial: String?
    @NSManaged public var state: Int16
    @NSManaged public var theme: String?
    @NSManaged public var code: Int64
    @NSManaged public var group: Group?
    @NSManaged public var students: NSSet?
    @NSManaged public var teacher: Teacher?

}

// MARK: Generated accessors for students
extension Lecture {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension Lecture : Identifiable {

}
