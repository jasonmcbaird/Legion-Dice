//
//  Simulation.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import Foundation

struct Simulation {
  
  let attackDice: [AttackDie]
  let crits: Int
  let hits: Int
  let defenseDice: [DefenseDie]
  let blocks: Int
  let wounds: Int
  
  init(configuration: Configuration) {
    attackDice = configuration.attackDice.roll()
    let surgeCrits = configuration.offensiveSurge == .crit ? attackDice.rawSurges : 0
    crits = attackDice.rawCrits + surgeCrits
    
    let surgeHits = configuration.offensiveSurge == .hit ? attackDice.rawSurges : 0
    let surgeTokenHits = configuration.offensiveSurge == .blank ? min(attackDice.rawSurges, configuration.offensiveSurgeTokens) : 0
    hits = attackDice.rawHits + surgeHits + surgeTokenHits
    
    let hitsThroughDefenses = max(hits - configuration.cover.removedHits, 0)
    defenseDice = Array(repeating: configuration.save, count: crits + hitsThroughDefenses).roll()
    
    let surgeBlocks = configuration.defensiveSurge == DefenseDie.Face.block ? defenseDice.rawSurges : 0
    let surgeTokenBlocks = configuration.defensiveSurge == .blank ? min(defenseDice.rawSurges, configuration.defensiveSurgeTokens) : 0
    blocks = defenseDice.rawBlocks + surgeBlocks + surgeTokenBlocks
    
    wounds = crits + hitsThroughDefenses - blocks
  }
  
}


