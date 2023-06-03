//
//  Constants.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 28.02.23.
//

import Foundation


enum HttpErrors : Error{
    case badUrl
}

enum Constants{
    static let baseURL = "https://76b8-37-215-9-51.ngrok-free.app"
}

enum Endpoints{
    static let users = "/users"
    static let login = "/login"
    static let attach = "/attach"
    static let lectures = "/lectures"
    static let groups = "/groups"
    static let checkStudents = "/checkStudents"
    static let checkForStudent = "/checkForStudent"
    static let forUser = "/forUser"
    static let forStudent = "/forStudent"
    static let getStudentsForLecture = "/getStudentsForLecture"
    static let students = "/students"
    static let regenerate = "/regenerate"
    static let one = "/one"
    static let mark = "/mark"
    //static let
}
