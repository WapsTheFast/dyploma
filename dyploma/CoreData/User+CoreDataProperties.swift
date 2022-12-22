//
//  User+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 22.12.22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var id: UUID?
    @NSManaged public var teacher: Teacher?
    @NSManaged public var student: Student?

}

extension User : Identifiable {

}
