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
    let surgeCrits = configuration.offensiveSurge == AttackDie.Face.crit ? attackDice.rawSurges : 0
    crits = attackDice.rawCrits + surgeCrits
    
    let surgeHits = configuration.offensiveSurge == AttackDie.Face.hit ? attackDice.rawSurges : 0
    hits = attackDice.rawHits + surgeHits
    
    let hitsThroughDefenses = max(hits - configuration.cover.removedHits, 0)
    defenseDice = Array(repeating: configuration.save, count: crits + hitsThroughDefenses).roll()
    
    let surgeBlocks = configuration.defensiveSurge == DefenseDie.Face.block ? defenseDice.rawSurges : 0
    blocks = defenseDice.rawBlocks + surgeBlocks
    
    wounds = crits + hitsThroughDefenses - blocks
  }
  
}


