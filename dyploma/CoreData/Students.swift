//
//  Students.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import Foundation
import CoreData

@objc public enum LectureState : Int{
    
    case planned, ongoing, ended
}

var users : [User] = []
var students : [Student] = []
var teachers : [Teacher] = []
var groups : [Group] = []
var lectures : [Lecture] = []
