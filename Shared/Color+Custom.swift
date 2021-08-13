import SwiftUI

extension Color {
  enum DarkCompatible {
    static func offBlack(colorScheme: ColorScheme) -> Color {
      return colorScheme == .light ? Color(white: 0.2) : Color(white: 0.95)
    }
  }
}
