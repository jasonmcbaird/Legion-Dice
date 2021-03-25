//
//  OptionRow.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

struct OptionRow: View {
  @Binding var option: Option
  
  var body: some View {
    HStack {
      Text(option.name)
      Spacer()
      if option.interaction.isCounter {
        Counter(count: $option.interaction.count)
      } else if option.interaction.isRadio {
        Radio(buttons: option.interaction.buttons, selected: $option.interaction.count)
      }
    }.padding()
  }
}

struct OptionRow_Previews: PreviewProvider {
  static var previews: some View {
    OptionRow(option: .constant(Option(name: "Red Attack Dice", interaction: .counter(0))))
  }
}

