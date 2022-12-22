//
//  Group+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 22.12.22.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String?
    @NSManaged public var course: String?
    @NSManaged public var teachers: NSSet?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for teacher
extension Group {

    @objc(addTeacherObject:)
    @NSManaged public func addToTeachers(_ value: Teacher)

    @objc(removeTeacherObject:)
    @NSManaged public func removeFromTeachers(_ value: Teacher)

    @objc(addTeacher:)
    @NSManaged public func addToTeachers(_ values: NSSet)

    @objc(removeTeacher:)
    @NSManaged public func removeFromTeachers(_ values: NSSet)

}

// MARK: Generated accessors for student
extension Group {

    @objc(addStudentObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension Group : Identifiable {

}
