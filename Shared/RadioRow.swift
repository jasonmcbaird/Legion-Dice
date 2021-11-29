import SwiftUI

struct RadioRow: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Binding var option: Option
  let emphasized: Bool
  
  var body: some View {
    HStack {
      if emphasized {
        Text("\(option.name):")
          .font(.system(.footnote).bold())
          .foregroundColor(Color.DarkCompatible.offBlack(colorScheme: colorScheme))
      } else {
        Text("\(option.name):")
          .font(.system(.caption))
          .foregroundColor(Color.DarkCompatible.offBlack(colorScheme: colorScheme))
      }
      Spacer()
      Radio(buttons: option.interaction.buttons, selected: $option.interaction.count)
    }.padding(.leading, 4)
    .overlay(
      RoundedRectangle(cornerRadius: 4)
        .stroke(Color.DarkCompatible.lightGray(colorScheme: colorScheme), lineWidth: 2))
  }
}

struct RadioRow_Previews: PreviewProvider {
  static var previews: some View {
    RadioRow(option: .constant(Option(name: "Dude", interaction: .radio(buttons: [Option.Interaction.RadioButton(name: "Guy"), Option.Interaction.RadioButton(name: "Buddy")], selected: Option.Interaction.RadioButton(name: "None")))), emphasized: false)
  }
}
