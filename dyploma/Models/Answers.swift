//
//  Answers.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation

final class Answers : Codable{
    var id: UUID?
    var user : AnswersStudent
    var lecture : AnswersLecture
    var questions : AnswersQuestions
    var name: String
    var answersPath : String
    
    init(id : UUID? = nil, name : String, answersPath : String, userID : UUID, lectureID : UUID, questionsID : UUID){
        self.id = id
        self.name = name
        self.answersPath = answersPath
        self.user = AnswersStudent(id: userID)
        self.lecture = AnswersLecture(id: lectureID)
        self.questions = AnswersQuestions(id: questionsID)
    }
}

final class AnswersStudent: Codable{
    var id : UUID
    
    init(id: UUID){
        self.id = id
    }
}

final class AnswersLecture: Codable{
    var id : UUID
    
    init(id: UUID){
        self.id = id
    }
}

final class AnswersQuestions: Codable{
    var id : UUID
    
    init(id: UUID){
        self.id = id
    }
}
