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
    // If you have enough blank dice for a full aim, reroll those
    guard configuration.rerollCount > bestBlankDice.count else {
      return Array(bestBlankDice)
    }
    let hitsRemovedByDefenses = configuration.hitsRemovedByDefenses
    let currentHits = attackDice.getHits(configuration: configuration)
    let hitsNeededToBreakDefenses = hitsRemovedByDefenses - currentHits
    let potentialNewHits = min(bestBlankDice.count, aimsRemaining * configuration.rerollCount)
    let shouldCritFish: Bool
    if configuration.fullArmor {
      // If you have:
      // 1. Impact against full armor
      // 2. Don't have enough blanks to fill your aims
      // 3. Already maxed out your impact
      // Then crit-fish with extra hits beyond impact
      shouldCritFish = currentHits >= configuration.impact
    } else {
      // If you can't break the target's cover and dodges through rerolling blanks,
      // then crit-fish.
      shouldCritFish = hitsNeededToBreakDefenses >= potentialNewHits
    }
    guard shouldCritFish else { return Array(bestBlankDice) }
    // Crit-fish because either:
    // 1. You can't break their cover and dodges, or
    // 2. You've already used all your impact against full armor
    let hits = Array(attackDice.filter { $0.face == .hit } + attackDice.getSurgesConvertedToHits(configuration: configuration))
    let bestNonCrits = bestBlankDice + hits
    let numberOfHitsThatCouldBeRerolled = configuration.rerollCount - bestBlankDice.count
    let numberOfHitsToReroll: Int
    if configuration.fullArmor {
      let extraHitsBeyondImpact = max(0, currentHits - configuration.impact)
      numberOfHitsToReroll = min(numberOfHitsThatCouldBeRerolled, extraHitsBeyondImpact)
    } else {
      numberOfHitsToReroll = numberOfHitsThatCouldBeRerolled
    }
    return Array(bestNonCrits.prefix(numberOfHitsToReroll))
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
