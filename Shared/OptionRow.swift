import SwiftUI

struct OptionRow: View {
  @Binding var option: Option
  let emphasized: Bool
  
  var body: some View {
    if option.interaction.isCounter {
      Counter(count: $option.interaction.count,
              name: option.name,
              emphasized: emphasized)
        .padding(.horizontal, 2)
        .padding(.vertical, 2)
    } else if option.interaction.isRadio {
      RadioRow(option: $option,
               emphasized: emphasized)
      .padding(.vertical, 3)
    }
  }
}

struct OptionRow_Previews: PreviewProvider {
  static var previews: some View {
    OptionRow(option: .constant(Option(name: "Red Attack Dice", interaction: .counter(0))), emphasized: true)
    OptionRow(option: .constant(Option(name: "Armor", interaction: .radio(buttons: [Option.Interaction.RadioButton(name: "Full"), Option.Interaction.RadioButton(name: "None")], selected: Option.Interaction.RadioButton(name: "None")))), emphasized: false)
  }
}

