import SwiftUI

struct Radio: View {
  
  @Environment(\.colorScheme) var colorScheme
  var buttons: [Option.Interaction.RadioButton]
  @Binding var selected: Int
  
  var body: some View {
    HStack(spacing: 3) {
      ForEach(0..<buttons.count) { index in
        Button(buttons[index].name) {
          selected = index
        }.font(.system(.caption2))
        .foregroundColor(index == selected ? .white : Color.DarkCompatible.darkGray(colorScheme: colorScheme))
        .padding(2)
        .background(index == selected ? Color.accentColor : Color.DarkCompatible.offWhite(colorScheme: colorScheme))
        .cornerRadius(5)
      }
    }
  }
}

struct Radio_Previews: PreviewProvider {
  static let buddy = Option.Interaction.RadioButton(name: "Buddy")
  static var previews: some View {
    Radio(buttons: [.init(name: "Guy"), buddy], selected: .constant(0))
  }
}
