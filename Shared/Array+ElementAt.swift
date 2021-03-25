//
//  Array+ElementAt.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import Foundation

extension Array {
  func element(at index: Int) -> Element? {
    guard index >= 0, index < count else { return nil }
    return self[index]
  }
}
