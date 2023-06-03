//
//  User.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation

enum Role : String, Codable, CaseIterable{
    case student, teacher, administrator
}

final class User: Codable {
    var id: UUID?
    var name: String
    var surname: String
    var role: Role
    var email: String
    var username: String

    init(id : UUID? = nil,
         name: String, surname: String, role: String, email : String,
         username : String
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        switch role{
        case "administrator":
            self.role = .administrator
        case "teacher":
            self.role = .teacher
        case "student":
            self.role = .student
        default:
            self.role = .student
        }
        self.email = email
        self.username = username
    }
}
