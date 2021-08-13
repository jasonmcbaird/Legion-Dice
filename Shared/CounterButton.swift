import SwiftUI

struct CounterButton: View {
  let text: String
  let callback: () -> ()
  
  var body: some View {
    Button(action: {
      callback()
    }, label: {
      Text(text)
    }).padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(Color(white: 0.9))
    .cornerRadius(4)
  }
}

struct CounterButton_Previews: PreviewProvider {
  static var previews: some View {
    CounterButton(text: "+", callback: {})
  }
}
