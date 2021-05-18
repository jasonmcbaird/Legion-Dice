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
  
  var quality: Int {
    switch color {
    case .red: return 3
    case .black: return 2
    case .white: return 1
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
    let surgesAfterCritical = rawSurges - getCriticalXCrits(configuration: configuration)
    let surgeHits = configuration.offensiveSurge == .hit ? (surgesAfterCritical) : 0
    let surgeTokenHits = configuration.offensiveSurge == .blank ? Swift.min(surgesAfterCritical, configuration.offensiveSurgeTokens) : 0
    return rawHits + surgeHits + surgeTokenHits - getRamCrits(configuration: configuration)
  }
  
  private func getCritsWithoutRam(configuration: Configuration) -> Int {
    let surgeCrits = configuration.offensiveSurge == .crit ? rawSurges : 0
    let criticalXCrits = getCriticalXCrits(configuration: configuration)
    return rawCrits + surgeCrits + criticalXCrits
  }
  
  func getCriticalXCrits(configuration: Configuration) -> Int {
    return configuration.offensiveSurge == .crit ? 0 : Swift.min(configuration.critical, rawSurges)
  }
  
  func getRamCrits(configuration: Configuration) -> Int {
    return Swift.min(count - getCritsWithoutRam(configuration: configuration), configuration.ram)
  }
  
  func getConvertedCrits(configuration: Configuration) -> Int {
    return getCritsWithoutRam(configuration: configuration) + getRamCrits(configuration: configuration)
  }
  
  func sortedByQuality() -> [AttackDie] {
    return sorted { left, right -> Bool in
      return left.quality > right.quality
    }
  }
}
