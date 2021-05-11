import Foundation

class AttackDie {
  
  let color: Color
  var face: Face
  
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
  
  func roll() {
    let roll = Int.random(in: 1...8)
    switch roll {
    case 1...5:
      let hit = hitSideCount >= roll
      self.face = hit ? .hit : .blank
    case 6:
      self.face = .crit
    case 7:
      self.face = .surge
    case 8:
      self.face = .blank
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
  
  func roll() {
    return forEach { $0.roll() }
  }
  
  func getHits(configuration: Configuration) -> Int {
    let surgeHits = configuration.offensiveSurge == .hit ? rawSurges : 0
    let surgeTokenHits = configuration.offensiveSurge == .blank ? Swift.min(rawSurges, configuration.offensiveSurgeTokens) : 0
    return rawHits + surgeHits + surgeTokenHits
  }
}
