//
//  Group.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation


final class Group: Codable{
    var id: UUID?
    var name: String
    var course: String
    var color: String?
    var inviteCode : Int?
    
    init(id : UUID? = nil, name : String, course : String, color: String? = nil, inviteCode: Int? = nil){
        self.id = id
        self.name = name
        self.course = course
        self.color = color
        self.inviteCode = inviteCode
    }
}
