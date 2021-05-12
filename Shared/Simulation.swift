import Foundation

struct Simulation {
  
  let attackDice: [AttackDie]
  let crits: Int
  let hits: Int
  let defenseDice: [DefenseDie]
  let blocks: Int
  let wounds: Int
  
  // TODO: Unit test the crap out of this
  
  init(configuration: Configuration) {
    attackDice = configuration.attackDice
    
    attackDice.roll()
    
    AimStrategy().spendAims(configuration: configuration, attackDice: attackDice)
    
    let surgeCrits = configuration.offensiveSurge == .crit ? attackDice.rawSurges : 0
    let criticalX = attackDice.getCriticalX(configuration: configuration)
    crits = attackDice.rawCrits + surgeCrits + criticalX
    
    hits = attackDice.getHits(configuration: configuration)
    
    let hitsThroughDefenses = configuration.armor ? 0 : max(hits - configuration.hitsRemovedByDefenses, 0)
    if let save = configuration.save {
      let defenseDiceCount = crits + hitsThroughDefenses + (configuration.impervious ? configuration.pierce : 0) + configuration.dangerSense
      defenseDice = Array(repeating: save, count: defenseDiceCount).roll()
    } else {
      defenseDice = []
    }
    
    let surgeBlocks = configuration.defensiveSurge == DefenseDie.Face.block ? defenseDice.rawSurges : 0
    let surgeTokenBlocks = configuration.defensiveSurge == .blank ? min(defenseDice.rawSurges, configuration.defensiveSurgeTokens) : 0
    blocks = max(0, defenseDice.rawBlocks + surgeBlocks + surgeTokenBlocks - configuration.pierce)
    
    wounds = max(0, crits + hitsThroughDefenses - blocks)
  }
  
}
