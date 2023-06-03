//
//  Subject.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation

final class Subject: Codable{
    var id: UUID?
    var name: String
    
    init(id : UUID? = nil, name : String){
        self.id = id
        self.name = name
    }
}
