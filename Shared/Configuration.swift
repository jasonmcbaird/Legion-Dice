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
  @Published var ram: Int
  @Published var aims: Int
  
  @Published var cover: Cover
  @Published var dodges: Int
  @Published var save: DefenseDie?
  @Published var defensiveSurge: DefenseDie.Face
  @Published var defensiveSurgeTokens: Int
  @Published var fullArmor: Bool
  @Published var armorX: Int
  @Published var impervious: Bool
  @Published var dangerSense: Int
  @Published var uncannyLuck: Int
  
  // TODO: armor X aim strategy
  // TODO: (Low priority) Lethal, outmaneuver, marksman, observation tokens, poison X, Full of Surprises
  
  var rerollCount: Int {
    return 2 + precise
  }
  
  init(redOffense: Int = 0,
       blackOffense: Int = 0,
       whiteOffense: Int = 0,
       offensiveSurge: AttackDie.Face = .blank,
       offensiveSurgeTokens: Int = 0,
       critical: Int = 0,
       pierce: Int = 0,
       precise: Int = 0,
       impact: Int = 0,
       ram: Int = 0,
       aims: Int = 0,
       cover: Cover = .none,
       dodges: Int = 0,
       save: DefenseDie? = nil,
       defensiveSurge: DefenseDie.Face = .blank,
       defensiveSurgeTokens: Int = 0,
       fullArmor: Bool = false,
       armorX: Int = 0,
       impervious: Bool = false,
       dangerSense: Int = 0,
       uncannyLuck: Int = 0) {
    self.redOffense = redOffense
    self.blackOffense = blackOffense
    self.whiteOffense = whiteOffense
    self.offensiveSurge = offensiveSurge
    self.offensiveSurgeTokens = offensiveSurgeTokens
    self.critical = critical
    self.pierce = pierce
    self.precise = precise
    self.impact = impact
    self.ram = ram
    self.aims = aims
    self.cover = cover
    self.dodges = dodges
    self.save = save
    self.defensiveSurge = defensiveSurge
    self.defensiveSurgeTokens = defensiveSurgeTokens
    self.fullArmor = fullArmor
    self.armorX = armorX
    self.impervious = impervious
    self.dangerSense = dangerSense
    self.uncannyLuck = uncannyLuck
  }
  
  var attackDice: [AttackDie] {
    return Array(repeating: (), count: redOffense).map { AttackDie(color: .red) } +
      Array(repeating: (), count: blackOffense).map { AttackDie(color: .black) } +
      Array(repeating: (), count: whiteOffense).map { AttackDie(color: .white) }
  }
  
  var hitsRemovedByBasicDefenses: Int {
    return cover.removedHits + dodges
  }
  
  func hitsThroughArmorX(hitsThroughBasicDefenses: Int) -> Int {
    let impactCrits = max(hitsThroughBasicDefenses, impact)
    let armorableHits = hitsThroughBasicDefenses - impactCrits
    return impactCrits + max(armorableHits - armorX, 0)
  }
  
  // TODO: Reduce duplication on these vars
  
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
      Option(name: "Surges", interaction: .counter(offensiveSurgeTokens))
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
  
  var ramOption: Option {
    get {
      Option(name: "Ram", interaction: .counter(ram))
    }
    set {
      ram = newValue.interaction.count
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
      Option(name: "Surges", interaction: .counter(defensiveSurgeTokens))
    }
    set {
      defensiveSurgeTokens = newValue.interaction.count
    }
  }
  
  var fullArmorOption: Option {
    get {
      let noneButton = Option.Interaction.RadioButton(name: "None")
      let fullButton = Option.Interaction.RadioButton(name: "Full")
      return Option(name: "Armor", interaction: .radio(buttons: [noneButton, fullButton], selected: fullArmor ? fullButton : noneButton))
    }
    set {
      fullArmor = newValue.interaction.count == 1 ? true : false
    }
  }
  
  var armorXOption: Option {
    get {
      Option(name: "Armor X", interaction: .counter(armorX))
    }
    set {
      armorX = newValue.interaction.count
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
  
  var uncannyLuckOption: Option {
    get {
      Option(name: "Uncanny Luck", interaction: .counter(uncannyLuck))
    }
    set {
      uncannyLuck = newValue.interaction.count
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
