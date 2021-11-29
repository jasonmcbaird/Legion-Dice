import SwiftUI

extension Color {
  enum DarkCompatible {
    static func offBlack(colorScheme: ColorScheme) -> Color {
      return colorScheme == .light ? Color(white: 0.2) : Color(white: 0.95)
    }
    
    static func offWhite(colorScheme: ColorScheme) -> Color {
      return colorScheme == .light ? Color(white: 0.9) : Color(white: 0.25)
    }
    
    static func darkGray(colorScheme: ColorScheme) -> Color {
      return colorScheme == .light ? Color(white: 0.3) : Color(white: 0.8)
    }
    
    static func lightGray(colorScheme: ColorScheme) -> Color {
      return colorScheme == .light ? Color(white: 0.7) : Color(white: 0.35)
    }
  }
}
