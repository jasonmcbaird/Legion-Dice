//
//  Radio.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

struct Radio: View {
  var buttons: [Option.Interaction.RadioButton]
  @Binding var selected: Int
  
  var body: some View {
    HStack {
      ForEach(0..<buttons.count) { index in
        Button(buttons[index].name) {
          selected = index
        }.foregroundColor(.white)
        .padding(3)
        .background(index == selected ? Color.black : Color.blue)
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
