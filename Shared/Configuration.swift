//
//  Option.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

class Configuration: ObservableObject {
  
  @Published var redOffense: Int
  @Published var blackOffense: Int
  @Published var whiteOffense: Int
  @Published var offensiveSurge: AttackDie.Face
  @Published var cover: Cover
  @Published var save: DefenseDie
  @Published var defensiveSurge: DefenseDie.Face
  // TODO: surge tokens, aims, critical, pierce, impact, precise, marksman, lethal, ram
  // TODO: surge tokens, dodges, armor, armor X, danger sense X, uncanny luck X, impervious
  
  init(redOffense: Int = 0,
       blackOffense: Int = 4,
       whiteOffense: Int = 6,
       offensiveSurge: AttackDie.Face = .blank,
       cover: Cover = .heavy,
       save: DefenseDie = .init(color: .red),
       defensiveSurge: DefenseDie.Face = .block) {
    self.redOffense = redOffense
    self.blackOffense = blackOffense
    self.whiteOffense = whiteOffense
    self.offensiveSurge = offensiveSurge
    self.cover = cover
    self.save = save
    self.defensiveSurge = defensiveSurge
  }
  
  var attackDice: [AttackDie] {
    return Array(repeating: AttackDie(color: .red), count: redOffense) +
      Array(repeating: AttackDie(color: .black), count: blackOffense) +
      Array(repeating: AttackDie(color: .white), count: whiteOffense)
  }
  
  var redOffenseOption: Option {
    get {
      Option(name: "Red Offense", interaction: .counter(redOffense))
    }
    set {
      redOffense = newValue.interaction.count
    }
  }
  
  var blackOffenseOption: Option {
    get {
      Option(name: "Black Offense", interaction: .counter(blackOffense))
    }
    set {
      blackOffense = newValue.interaction.count
    }
  }
  
  var whiteOffenseOption: Option {
    get {
      Option(name: "White Offense", interaction: .counter(whiteOffense))
    }
    set {
      whiteOffense = newValue.interaction.count
    }
  }
  
  var offensiveSurgeOption: Option {
    get {
      Option(name: "Offensive Surge", interaction: .radio(buttons: AttackDie.Face.surgableCases.map { .init(name: $0.rawValue) }, selected: .init(name: offensiveSurge.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        offensiveSurge = .blank
        return
      }
      offensiveSurge = AttackDie.Face(rawValue: radioButton.name) ?? .blank
    }
  }
  
  var coverOption: Option {
    get {
      Option(name: "Cover", interaction: .radio(buttons: Cover.allCases.map { .init(name: $0.rawValue) }, selected: .init(name: cover.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        cover = .heavy
        return
      }
      cover = Cover(rawValue: radioButton.name) ?? .heavy
    }
  }
  
  var saveOption: Option {
    get {
      Option(name: "Save", interaction: .radio(buttons: DefenseDie.Color.allCases.map { .init(name: $0.rawValue) }, selected: .init(name: save.color.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        save = DefenseDie(color: .red)
        return
      }
      save = DefenseDie(color: DefenseDie.Color(rawValue: radioButton.name) ?? .red)
    }
  }
  
  var defensiveSurgeOption: Option {
    get {
      Option(name: "Defensive Surge", interaction: .radio(buttons: DefenseDie.Face.surgableCases.map { .init(name: $0.rawValue) }, selected: .init(name: defensiveSurge.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        defensiveSurge = .blank
        return
      }
      defensiveSurge = DefenseDie.Face(rawValue: radioButton.name) ?? .blank
    }
  }
  
  enum Cover: String, CaseIterable {
    case none = "None"
    case light = "Light"
    case heavy = "Heavy"
    
    var removedHits: Int {
      switch self {
      case .none: return 0
      case .light: return 1
      case .heavy: return 2
      }
    }
  }
}
