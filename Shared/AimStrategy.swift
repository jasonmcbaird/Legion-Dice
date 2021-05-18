import Foundation

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
    let canBreakDefenses = !configuration.fullArmor && potentialHits > hitsNeededToBreakDefenses
    guard !canBreakDefenses else { return Array(bestBlankDice) }
    let hits = Array(attackDice.filter { $0.face == .hit } + attackDice.getSurgesConvertedToHits(configuration: configuration))
    let bestNonCrits = (hits + bestBlankDice).sortedByQuality()
    return Array(bestNonCrits.prefix(configuration.rerollCount - bestBlankDice.count))
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
