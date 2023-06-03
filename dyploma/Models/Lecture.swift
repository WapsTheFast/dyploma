//
//  Lecture.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation

enum LectureState : String, Codable, CaseIterable{
    case onGoing, planned, done
}

final class Lecture: Codable {
    var id: UUID?
    var group : LectureGroup
    var user : LectureCreator
    var subject : LectureSubject
    var name: String
    var date : String
    var state : LectureState
    var code: UUID?
    var matherialPath: String?
    
    var dateValue: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter.date(from: date)
        }
    
    init(id: UUID? = nil, name: String, date: String, state : String, code: UUID? = nil, matherialPath : String? = nil, groupID : UUID, userID : UUID, subjectID : UUID) {
        self.id = id
        self.name = name
        self.date = date
        switch state{
        case "onGoing":
            self.state = .onGoing
        case "planned":
            self.state = .planned
        case "done":
            self.state = .done
        default:
            self.state = .planned
                }
        self.code = code
        self.matherialPath = matherialPath
        self.group = LectureGroup(id: groupID)
        self.user = LectureCreator(id: userID)
        self.subject = LectureSubject(id: subjectID)
    }
}

final class LectureGroup : Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}

final class LectureCreator : Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}

final class LectureSubject : Codable{
    var id: UUID

    init(id: UUID) {
      self.id = id
    }
}
