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
  @Published var offensiveSurgeTokens: Int
  @Published var aims: Int
  @Published var pierce: Int
  @Published var rerollCount: Int = 2
  
  @Published var cover: Cover
  @Published var save: DefenseDie
  @Published var defensiveSurge: DefenseDie.Face
  @Published var defensiveSurgeTokens: Int
  @Published var armor: Bool
  // TODO: surge tokens, aims, critical, pierce, impact, precise, marksman, lethal, ram
  // TODO: surge tokens, dodges, armor, armor X, danger sense X, uncanny luck X, impervious
  
  init(redOffense: Int = 0,
       blackOffense: Int = 4,
       whiteOffense: Int = 6,
       offensiveSurge: AttackDie.Face = .blank,
       offensiveSurgeTokens: Int = 0,
       aims: Int = 0,
       pierce: Int = 0,
       cover: Cover = .heavy,
       save: DefenseDie = .init(color: .red),
       defensiveSurge: DefenseDie.Face = .blank,
       defensiveSurgeTokens: Int = 0,
       armor: Bool = false) {
    self.redOffense = redOffense
    self.blackOffense = blackOffense
    self.whiteOffense = whiteOffense
    self.offensiveSurge = offensiveSurge
    self.aims = aims
    self.pierce = pierce
    self.cover = cover
    self.save = save
    self.defensiveSurge = defensiveSurge
    self.offensiveSurgeTokens = offensiveSurgeTokens
    self.defensiveSurgeTokens = defensiveSurgeTokens
    self.armor = armor
  }
  
  var attackDice: [AttackDie] {
    return Array(repeating: (), count: redOffense).map { AttackDie(color: .red) } +
      Array(repeating: (), count: blackOffense).map { AttackDie(color: .black) } +
      Array(repeating: (), count: whiteOffense).map { AttackDie(color: .white) }
  }
  
  var hitsRemovedByDefenses: Int {
    return cover.removedHits
  }
  
  var redOffenseOption: Option {
    get {
      Option(name: "Red", interaction: .counter(redOffense))
    }
    set {
      redOffense = newValue.interaction.count
    }
  }
  
  var blackOffenseOption: Option {
    get {
      Option(name: "Black", interaction: .counter(blackOffense))
    }
    set {
      blackOffense = newValue.interaction.count
    }
  }
  
  var whiteOffenseOption: Option {
    get {
      Option(name: "White", interaction: .counter(whiteOffense))
    }
    set {
      whiteOffense = newValue.interaction.count
    }
  }
  
  var offensiveSurgeOption: Option {
    get {
      Option(name: "Surge", interaction: .radio(buttons: AttackDie.Face.surgableCases.map { .init(name: $0.rawValue) }, selected: .init(name: offensiveSurge.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        offensiveSurge = .blank
        return
      }
      offensiveSurge = AttackDie.Face(rawValue: radioButton.name) ?? .blank
    }
  }
  
  var offensiveSurgeTokensOption: Option {
    get {
      Option(name: "Surge Tokens", interaction: .counter(offensiveSurgeTokens))
    }
    set {
      offensiveSurgeTokens = newValue.interaction.count
    }
  }
  
  var aimsOption: Option {
    get {
      Option(name: "Aims", interaction: .counter(aims))
    }
    set {
      aims = newValue.interaction.count
    }
  }
  
  var pierceOption: Option {
    get {
      Option(name: "Pierce", interaction: .counter(pierce))
    }
    set {
      pierce = newValue.interaction.count
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
      Option(name: "Surge", interaction: .radio(buttons: DefenseDie.Face.surgableCases.map { .init(name: $0.rawValue) }, selected: .init(name: defensiveSurge.rawValue)))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        defensiveSurge = .blank
        return
      }
      defensiveSurge = DefenseDie.Face(rawValue: radioButton.name) ?? .blank
    }
  }
  
  var defensiveSurgeTokensOption: Option {
    get {
      Option(name: "Surge Tokens", interaction: .counter(defensiveSurgeTokens))
    }
    set {
      defensiveSurgeTokens = newValue.interaction.count
    }
  }
  
  var armorOption: Option {
    get {
      let noneButton = Option.Interaction.RadioButton(name: "None")
      let fullButton = Option.Interaction.RadioButton(name: "Full")
      return Option(name: "Armor", interaction: .radio(buttons: [noneButton, fullButton], selected: armor ? fullButton : noneButton))
    }
    set {
      armor = newValue.interaction.count == 1 ? true : false
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
