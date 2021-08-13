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
    
    crits = attackDice.getConvertedCrits(configuration: configuration)
    
    hits = attackDice.getHits(configuration: configuration)
    
    let hitsThroughBasicDefenses = max(hits - configuration.hitsRemovedByBasicDefenses, 0)
    let hitsThroughArmorX = configuration.hitsThroughArmorX(hitsThroughBasicDefenses: hitsThroughBasicDefenses)
    let hitsThroughFullArmor = configuration.fullArmor ?
      min(hitsThroughBasicDefenses, configuration.impact) :
      hitsThroughBasicDefenses
    let hitsThroughDefenses = min(hitsThroughArmorX, hitsThroughFullArmor)
    if let save = configuration.save {
      let defenseDiceCount = crits + hitsThroughDefenses + (configuration.impervious ? configuration.pierce : 0) + configuration.dangerSense
      defenseDice = Array(repeating: save, count: defenseDiceCount).map { DefenseDie(color: $0.color) }
      defenseDice.roll()
      defenseDice.spendUncannyLuckDice(configuration: configuration)
    } else {
      defenseDice = []
    }
    
    let surgeBlocks = configuration.defensiveSurge == DefenseDie.Face.block ? defenseDice.rawSurges : 0
    let surgeTokenBlocks = configuration.defensiveSurge == .blank ? min(defenseDice.rawSurges, configuration.defensiveSurgeTokens) : 0
    blocks = max(0, defenseDice.rawBlocks + surgeBlocks + surgeTokenBlocks - configuration.pierce)
    
    wounds = max(0, crits + hitsThroughDefenses - blocks)
  }
  
}
