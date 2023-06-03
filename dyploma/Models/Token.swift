//
//  Token.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 16.05.23.
//

import Foundation

final class Token: Codable {
  var id: UUID?
  var value: String

  init(value: String) {
    self.value = value
  }
}
