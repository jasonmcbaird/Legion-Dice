import SwiftUI

class Option: ObservableObject {
  
  @Published var name: String
  @Published var interaction: Interaction
  
  var interactionBinding: Binding<Interaction> {
    return Binding {
      self.interaction
    } set: { value in
      self.interaction = value
    }
  }
  
  init(name: String, interaction: Interaction) {
    self.name = name
    self.interaction = interaction
  }
  
  enum Interaction {
    case counter(Int)
    case toggle(Bool)
    case radio(buttons: [RadioButton], selected: RadioButton?)
    
    var count: Int {
      get {
        switch self {
        case .counter(let count): return count
        case .toggle(let isEnabled): return isEnabled ? 1 : 0
        case .radio(let buttons, let selected):
          return buttons.firstIndex { $0.name == selected?.name } ?? -1
        }
      }
      set {
        switch self {
        case .counter(_):
          self = .counter(newValue)
        case .toggle(_):
          self = .toggle(newValue == 1)
        case .radio(let buttons, _):
          self = .radio(buttons: buttons, selected: buttons.element(at: newValue))
        }
      }
    }
    
    var isCounter: Bool {
      guard case .counter(_) = self else { return false }
      return true
    }
    
    var isToggle: Bool {
      guard case .toggle(_) = self else { return false }
      return true
    }
    
    var isRadio: Bool {
      guard case .radio(_, _) = self else { return false }
      return true
    }
    
    var buttons: [RadioButton] {
      guard case .radio(let buttons, _) = self else { return [] }
      return buttons
    }
    
    class RadioButton: ObservableObject {
      @Published var name: String
      
      init(name: String) {
        self.name = name
      }
    }
  }
  
}

extension Option: Identifiable {
  var id: String {
    return name
  }
}

extension Option.Interaction.RadioButton: Identifiable {
  var id: String {
    return name
  }
}
