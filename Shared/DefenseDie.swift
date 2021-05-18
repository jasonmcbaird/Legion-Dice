import Foundation

class DefenseDie {
  
  let color: Color
  var face: Face
  
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
  
  func roll() {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1...4:
      let block = blockSideCount >= roll
      face = block ? .block : .blank
    case 5:
      return face = .surge
    case 6:
      return face = .blank
    default:
      fatalError("Random roll out of range")
    }
  }
  
  enum Color: String, CaseIterable {
    case white = "White"
    case red = "Red"
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
  
  func roll() {
    return forEach { $0.roll() }
  }
  
  func spendUncannyLuckDice(configuration: Configuration) {
    let uncannyLuckDice = getUncannyLuckDice(configuration: configuration)
    uncannyLuckDice.roll()
  }
  
  private func getUncannyLuckDice(configuration: Configuration) -> [DefenseDie] {
    let misses = getMisses(configuration: configuration)
    guard misses.count > configuration.uncannyLuck else {
      return misses
    }
    return Array(misses.prefix(configuration.uncannyLuck))
  }
  
  private func getMisses(configuration: Configuration) -> [DefenseDie] {
    let rawBlankDice = filter { $0.face == .blank }
    guard configuration.defensiveSurge == .blank else {
      return rawBlankDice
    }
    let rawSurgeDice = filter { $0.face == .surge }
    guard rawSurgeDice.count > configuration.defensiveSurgeTokens else {
      return rawBlankDice + rawSurgeDice
    }
    let unusedSurgeResults = Array(rawSurgeDice.prefix(configuration.defensiveSurgeTokens))
    return rawBlankDice + unusedSurgeResults
    // TODO: Examine cases where it's worth rerolling a surge result
  }
}
