import Foundation

struct Simulation {
  
  let attackDice: [AttackDie]
  let crits: Int
  let hits: Int
  let defenseDice: [DefenseDie]
  let blocks: Int
  let wounds: Int
  
  init(configuration: Configuration) {
    attackDice = configuration.attackDice
    
    attackDice.roll()
    
    AimStrategy().spendAims(configuration: configuration, attackDice: attackDice)
    
    let surgeCrits = configuration.offensiveSurge == .crit ? attackDice.rawSurges : 0
    let criticalX = attackDice.getCriticalX(configuration: configuration)
    crits = attackDice.rawCrits + surgeCrits + criticalX
    
    hits = attackDice.getHits(configuration: configuration)
    
    let hitsThroughDefenses = configuration.armor ? 0 : max(hits - configuration.hitsRemovedByDefenses, 0)
    defenseDice = Array(repeating: configuration.save, count: crits + hitsThroughDefenses).roll()
    
    let surgeBlocks = configuration.defensiveSurge == DefenseDie.Face.block ? defenseDice.rawSurges : 0
    let surgeTokenBlocks = configuration.defensiveSurge == .blank ? min(defenseDice.rawSurges, configuration.defensiveSurgeTokens) : 0
    blocks = max(0, defenseDice.rawBlocks + surgeBlocks + surgeTokenBlocks - configuration.pierce)
    
    wounds = crits + hitsThroughDefenses - blocks
  }
  
}

struct AimStrategy {
  
  func spendAims(configuration: Configuration, attackDice: [AttackDie], aimsRemaining: Int? = nil) {
    let aimsRemaining = aimsRemaining ?? configuration.aims
    guard aimsRemaining > 0 else { return }
    let diceToReroll = chooseDiceToReroll(configuration: configuration, attackDice: attackDice, aimsRemaining: aimsRemaining)
    diceToReroll.roll()
    spendAims(configuration: configuration, attackDice: attackDice, aimsRemaining: aimsRemaining - 1)
  }
  
  private func chooseDiceToReroll(configuration: Configuration, attackDice: [AttackDie], aimsRemaining: Int) -> [AttackDie] {
    let nonSurgingDice = attackDice.getUnusedSurges(configuration: configuration)
    let rawBlankDice = attackDice.filter { $0.face == .blank }
    let blankAfterSurgeDice = nonSurgingDice + rawBlankDice
    let bestBlankDice = blankAfterSurgeDice.prefix(configuration.rerollCount)
    guard configuration.rerollCount > bestBlankDice.count else {
      return Array(bestBlankDice)
    }
    let hitsRemovedByDefenses = configuration.hitsRemovedByDefenses
    let currentHits = attackDice.getHits(configuration: configuration)
    let hitsNeededToBreakDefenses = hitsRemovedByDefenses - currentHits
    let potentialHits = min(bestBlankDice.count, aimsRemaining * configuration.rerollCount)
    let canBreakDefenses = !configuration.armor && potentialHits > hitsNeededToBreakDefenses
    guard !canBreakDefenses else { return Array(bestBlankDice) }
    let hits = attackDice.filter { $0.face == .hit } + attackDice.getSurgesConvertedToHits(configuration: configuration)
    return bestBlankDice + Array(hits.prefix(configuration.rerollCount - bestBlankDice.count))
  }
}

extension Array where Element == AttackDie {
  func getUnusedSurges(configuration: Configuration) -> [AttackDie] {
    guard configuration.offensiveSurge == .blank else { return [] }
    let surges = filter { $0.face == .surge }
    return surges.dropLast(configuration.critical + configuration.offensiveSurgeTokens)
  }
  
  func getSurgesConvertedToHits(configuration: Configuration) -> [AttackDie] {
    switch configuration.offensiveSurge {
    case .crit:
      return []
    case .hit:
      return Array(filter { $0.face == .surge }.dropFirst(configuration.critical))
    case .blank:
      return filter { $0.face == .surge }.suffix(Swift.max(0, configuration.offensiveSurgeTokens - configuration.critical))
    case .surge:
      fatalError()
    }
  }
}
