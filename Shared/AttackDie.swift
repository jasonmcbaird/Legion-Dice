//
//  AttackDie.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import Foundation

struct AttackDie {
  
  let color: Color
  let face: Face
  
  var hitSideCount: Int {
    switch color {
    case .red: return 5
    case .black: return 3
    case .white: return 1
    }
  }
  
  init(color: Color, face: Face = .blank) {
    self.color = color
    self.face = face
  }
  
  func roll() -> AttackDie {
    let roll = Int.random(in: 1...8)
    switch roll {
    case 1...5:
      let hit = hitSideCount >= roll
      return AttackDie(color: color, face: hit ? .hit : .blank)
    case 6:
      return AttackDie(color: color, face: .crit)
    case 7:
      return AttackDie(color: color, face: .surge)
    case 8:
      return AttackDie(color: color, face: .blank)
    default:
      fatalError("Random roll out of range")
    }
  }
  
  enum Face: String, CaseIterable {
    case blank = "Blank"
    case surge = "Surge"
    case hit = "Hit"
    case crit = "Crit"
    
    static var surgableCases: [Face] = [.blank, .hit, .crit]
  }
  
  enum Color {
    case red, black, white
  }
}

extension Array where Element == AttackDie {
  var rawHits: Int {
    return filter { $0.face == .hit }.count
  }
  
  var rawCrits: Int {
    return filter { $0.face == .crit }.count
  }
  
  var rawSurges: Int {
    return filter { $0.face == .surge }.count
  }
  
  func roll() -> [AttackDie] {
    return map { $0.roll() }
  }
}
