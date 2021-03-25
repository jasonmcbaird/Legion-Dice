//
//  DefenseDie.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import Foundation

struct DefenseDie {
  
  let color: Color
  let face: Face
  
  var blockSideCount: Int {
    switch color {
    case .red: return 3
    case .white: return 1
    }
  }
  
  init(color: Color, face: Face = .blank) {
    self.color = color
    self.face = face
  }
  
  func roll() -> DefenseDie {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1...4:
      let block = blockSideCount >= roll
      return .init(color: color, face: block ? .block : .blank)
    case 5:
      return .init(color: color, face: .surge)
    case 6:
      return .init(color: color, face: .blank)
    default:
      fatalError("Random roll out of range")
    }
  }
  
  enum Color: String, CaseIterable {
    case red = "Red"
    case white = "White"
  }
  
  enum Face: String, CaseIterable {
    case blank = "Blank"
    case surge = "Surge"
    case block = "Block"
    
    static var surgableCases: [Face] = [.blank, .block]
  }
}

extension Array where Element == DefenseDie {
  var rawBlocks: Int {
    return filter { $0.face == .block }.count
  }
  
  var rawSurges: Int {
    return filter { $0.face == .surge }.count
  }
  
  func roll() -> [DefenseDie] {
    return map { $0.roll() }
  }
}
