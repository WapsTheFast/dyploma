//
//  ResourseRequestError.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//


import Foundation

enum ResourceRequestError: Error {
  case noData
  case decodingError
  case encodingError
}
