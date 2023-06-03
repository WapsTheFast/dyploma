//
//  Students.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import Foundation
import CoreData

//@objc public enum LectureState : Int{
//    
//    case planned, ongoing, ended
//}
//
//class UserModel : Codable{
//    var id : UUID?
//    
//    var username : String
//    
//    var password : String
//    
//    weak var student : StudentModel?
//    
//    weak var teacher : TeacherModel?
//    
//    init(id: UUID? = nil, username: String, password: String, student: StudentModel? = nil, teacher: TeacherModel? = nil) {
//        self.id = id
//        self.username = username
//        self.password = password
//        self.student = student
//        self.teacher = teacher
//    }
//    
//}
//
//class StudentModel : Codable{
//    var id : UUID?
//    var name : String
//    var user : UserModel
//    var group : GroupModel
//    var lectures : [LectureModel]
//    
//    init(id: UUID? = nil, name: String, user: UserModel, group: GroupModel, lectures: [LectureModel]) {
//        self.id = id
//        self.name = name
//        self.user = user
//        self.group = group
//        self.lectures = lectures
//    }
//    
//}
//
//class TeacherModel : Codable{
//    
//    var id : UUID?
//    
//    var name : String
//    
//    var groups : [GroupModel]
//    var user : UserModel
//    var lectures : [LectureModel]
//    
//    init(id: UUID? = nil, name: String, groups : [GroupModel], user: UserModel, lectures: [LectureModel]) {
//        self.id = id
//        self.name = name
//        self.groups = groups
//        self.user = user
//        self.lectures = lectures
//    }
//}
//
//class LectureModel : Codable{
//    var id : UUID?
//    
//    var code : Int64
//    
//    var date : Date?
//    
//    var matherial : String?
//    
//    var state : Int16
//    
//    var theme : String?
//    
//    var teacher : TeacherModel
//    
//    var group : GroupModel
//    
//    var students : [StudentModel]
//    
//    init(id: UUID? = nil, code: Int64, date: Date? = nil, matherial: String? = nil, state: Int16, theme: String? = nil, teacher: TeacherModel, group : GroupModel, student : [StudentModel]) {
//        self.id = id
//        self.code = code
//        self.date = date
//        self.matherial = matherial
//        self.state = state
//        self.theme = theme
//        self.teacher = teacher
//        self.group = group
//        self.students = student
//    }
//}
//
//class GroupModel : Codable{
//    
//    var id: UUID?
//    
//    var color: String?
//    
//    var course: String
//    
//    var inviteCode: Int64?
//    
//    var name: String
//    
//    var teachers : [TeacherModel]
//    
//    var students : [StudentModel]
//    
//    var lectures : [LectureModel]
//    
//    init(id: UUID? = nil, color: String? = nil, course: String, inviteCode: Int64? = nil, name: String,teachers : [TeacherModel], students: [StudentModel], lectures : [LectureModel]) {
//        self.id = id
//        self.color = color
//        self.course = course
//        self.inviteCode = inviteCode
//        self.name = name
//        self.teachers = teachers
//        self.students = students
//        self.lectures = lectures
//    }
//}

//var users : [User] = []
//var students : [Student] = []
//var teachers : [Teacher] = []
//var groups : [Group] = []
//var lectures : [Lecture] = []
