//
//  User+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.01.23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var student: Student?
    @NSManaged public var teacher: Teacher?

}

extension User : Identifiable {

}
