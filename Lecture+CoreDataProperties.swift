//
//  Lecture+CoreDataProperties.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 25.12.22.
//
//

import Foundation
import CoreData


extension Lecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var theme: String?
    @NSManaged public var matherial: String?
    @NSManaged public var status: Int16
    @NSManaged public var group: Group?
    @NSManaged public var students: Student?
    @NSManaged public var teacher: Teacher?
    @NSManaged public var date: Date?

}

extension Lecture : Identifiable {

}
