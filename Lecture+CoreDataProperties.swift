//
//  Lecture+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.01.23.
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
    @NSManaged public var group: Group?
    @NSManaged public var students: Student?
    @NSManaged public var teacher: Teacher?

}

extension Lecture : Identifiable {

}
