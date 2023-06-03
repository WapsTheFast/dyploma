//
//  Questions.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation


final class Questions : Codable{
    var id: UUID?
    var user : QuestionsCreator
    var lecture : QuestionsLecture
    var name: String
    var questionsPath : String
    
    init(id : UUID? = nil, name : String, questionsPath : String, userID : UUID, lectureID : UUID){
        self.id = id
        self.name = name
        self.questionsPath = questionsPath
        self.user = QuestionsCreator(id: userID)
        self.lecture = QuestionsLecture(id: lectureID)
    }
}

final class QuestionsCreator: Codable{
    var id: UUID
    
    init(id: UUID){
        self.id = id
    }
}

final class QuestionsLecture: Codable{
    var id: UUID
    
    init(id: UUID){
        self.id = id
    }
}
