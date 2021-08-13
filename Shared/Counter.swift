import SwiftUI

struct Counter: View {
  @Binding var count: Int
  let name: String
  let emphasized: Bool
  
  var body: some View {
    HStack {
      CounterButton(text: "-") {
        if $count.wrappedValue > 0 {
          count -= 1
        }
      }
      Spacer()
      if emphasized {
        Text("\(name): \($count.wrappedValue)")
          .font(.system(.footnote).bold())
          .foregroundColor(Color(white: 0.2))
      } else {
        Text("\(name): \($count.wrappedValue)")
          .font(.system(.caption))
          .foregroundColor(Color(white: 0.2))
      }
      Spacer()
      CounterButton(text: "+") {
        if $count.wrappedValue < 99 {
          count += 1
        }
      }
    }.overlay(
      RoundedRectangle(cornerRadius: 4)
        .stroke(Color(white: 0.7), lineWidth: 2))
  }
}

struct Counter_Previews: PreviewProvider {
  static var previews: some View {
    Counter(count: .constant(0), name: "Counter", emphasized: true)
  }
}
