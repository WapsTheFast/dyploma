//
//  Student+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 22.12.22.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var user: User?
    @NSManaged public var group: Group?

}
