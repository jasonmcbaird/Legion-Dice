import SwiftUI

struct Counter: View {
  @Binding var count: Int
  
  var body: some View {
    HStack {
      Text("\($count.wrappedValue)") // TODO: Float this to the right
      Stepper("", value: $count, in: 0...99)
    }
  }
}

struct Counter_Previews: PreviewProvider {
  static var previews: some View {
    Counter(count: .constant(0))
  }
}
