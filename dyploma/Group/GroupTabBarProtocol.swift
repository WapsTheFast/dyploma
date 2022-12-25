//
//  GroupTabBarProtocol.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import Foundation

protocol GroupTabBarProtocol{
    var group : Group! {get set}
    var teacher : Teacher! {get set}
    var delegate : GroupTabBarViewController! {get set}
}
