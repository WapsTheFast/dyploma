//
//  Students.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import Foundation
import CoreData

@objc public enum LectureState : Int{
    
    
    //public typealias RawValue = Int
    
    case planned, ongoing, ended
}

//extension LectureState : NSObject{
//    public init?(rawValue: Int) {
//        if rawValue == 0{
//            self = .planned
//        }else if rawValue == 1{
//            self = .ongoing
//        }else if rawValue == 2{
//            self = .ended
//        }
//
//    }
//
//    public var rawValue: Int{
//        if self == .planned{
//            return 0
//        }else if self == .ongoing{
//            return 1
//        }else if self == .ended{
//            return 2
//        }
//    }
//}

var users : [User] = []
var students : [Student] = []
var teachers : [Teacher] = []
var groups : [Group] = []
var lectures : [Lecture] = []
