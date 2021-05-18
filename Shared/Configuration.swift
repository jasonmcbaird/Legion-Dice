import SwiftUI

class Configuration: ObservableObject {
  
  @Published var redOffense: Int
  @Published var blackOffense: Int
  @Published var whiteOffense: Int
  @Published var offensiveSurge: AttackDie.Face
  @Published var offensiveSurgeTokens: Int
  @Published var critical: Int
  @Published var pierce: Int
  @Published var precise: Int
  @Published var impact: Int
  @Published var aims: Int
  
  @Published var cover: Cover
  @Published var dodges: Int
  @Published var save: DefenseDie?
  @Published var defensiveSurge: DefenseDie.Face
  @Published var defensiveSurgeTokens: Int
  @Published var armor: Bool
  @Published var impervious: Bool
  @Published var dangerSense: Int
  
  // TODO: impact X, ram X
  // TODO: armor X, uncanny luck X
  // TODO: (Low priority) Lethal, outmaneuver, marksman, observation tokens, poison X, Full of Surprises
  
  var rerollCount: Int {
    return 2 + precise
  }
  
  init(redOffense: Int = 0,
       blackOffense: Int = 4,
       whiteOffense: Int = 6,
       offensiveSurge: AttackDie.Face = .blank,
       offensiveSurgeTokens: Int = 0,
       critical: Int = 0,
       pierce: Int = 0,
       precise: Int = 0,
       impact: Int = 0,
       aims: Int = 0,
       cover: Cover = .heavy,
       dodges: Int = 0,
       save: DefenseDie? = .init(color: .red),
       defensiveSurge: DefenseDie.Face = .blank,
       defensiveSurgeTokens: Int = 0,
       armor: Bool = false,
       impervious: Bool = false,
       dangerSense: Int = 0) {
    self.redOffense = redOffense
    self.blackOffense = blackOffense
    self.whiteOffense = whiteOffense
    self.offensiveSurge = offensiveSurge
    self.offensiveSurgeTokens = offensiveSurgeTokens
    self.critical = critical
    self.pierce = pierce
    self.precise = precise
    self.impact = impact
    self.aims = aims
    self.cover = cover
    self.dodges = dodges
    self.save = save
    self.defensiveSurge = defensiveSurge
    self.defensiveSurgeTokens = defensiveSurgeTokens
    self.armor = armor
    self.impervious = impervious
    self.dangerSense = dangerSense
  }
  
  var attackDice: [AttackDie] {
    return Array(repeating: (), count: redOffense).map { AttackDie(color: .red) } +
      Array(repeating: (), count: blackOffense).map { AttackDie(color: .black) } +
      Array(repeating: (), count: whiteOffense).map { AttackDie(color: .white) }
  }
  
  var hitsRemovedByDefenses: Int {
    return cover.removedHits + dodges
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
  
  var criticalOption: Option {
    get {
      Option(name: "Critical", interaction: .counter(critical))
    }
    set {
      critical = newValue.interaction.count
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
  
  var preciseOption: Option {
    get {
      Option(name: "Precise", interaction: .counter(precise))
    }
    set {
      precise = newValue.interaction.count
    }
  }
  
  var impactOption: Option {
    get {
      Option(name: "Impact", interaction: .counter(impact))
    }
    set {
      impact = newValue.interaction.count
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
  
  var dodgesOption: Option {
    get {
      Option(name: "Dodges", interaction: .counter(dodges))
    }
    set {
      dodges = newValue.interaction.count
    }
  }
  
  var saveOption: Option {
    get {
      Option(name: "Save", interaction: .radio(buttons: DefenseDie.Color.allCases.map { .init(name: $0.rawValue) } + [Option.Interaction.RadioButton(name: "None")], selected: .init(name: save?.color.rawValue ?? "None")))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        save = DefenseDie(color: .red)
        return
      }
      save = DefenseDie.Color(rawValue: radioButton.name).flatMap { DefenseDie(color: $0) }
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
  
  var imperviousOption: Option {
    get {
      let yesButton = Option.Interaction.RadioButton(name: "Yes")
      let noButton = Option.Interaction.RadioButton(name: "No")
      return Option(name: "Impervious", interaction: .radio(buttons: [yesButton, noButton], selected: impervious ? yesButton : noButton))
    }
    set {
      guard let radioButton = newValue.interaction.buttons.element(at: newValue.interaction.count) else {
        impervious = false
        return
      }
      impervious = radioButton.name == "Yes"
    }
  }
  
  var dangerSenseOption: Option {
    get {
      Option(name: "Danger Sense", interaction: .counter(dangerSense))
    }
    set {
      dangerSense = newValue.interaction.count
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
