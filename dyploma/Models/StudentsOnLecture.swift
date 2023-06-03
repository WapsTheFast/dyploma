//
//  StudentsOnLecture.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation

enum StateOnLecture: String, Codable, CaseIterable{
    case onLecture, notOnLecture, late
}

final class StudentsOnLecture: Codable{
    var id: UUID?
    var group : onLectureGroup
    var lecture: onLectureLecture
    var user : onLectureStudent
    var state: StateOnLecture
    
    init(id : UUID? = nil, state : String, groupID : UUID, lectureID : UUID, userID : UUID){
        self.id = id
        self.group = onLectureGroup(id: groupID)
        self.lecture = onLectureLecture(id: lectureID)
        self.user = onLectureStudent(id: userID)
        switch state{
        case "onLecture":
            self.state = .onLecture
        case "notOnLecture":
            self.state = .notOnLecture
        case "late":
            self.state = .late
        default:
            self.state = .onLecture
        }
    }
}

final class onLectureGroup: Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}

final class onLectureLecture: Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}

final class onLectureStudent: Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}
