import SwiftUI

extension Color {
    static let CustomGray = Color(red: 50 / 255, green: 50 / 255, blue: 50 / 255)
    static let CustomLightGray = Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255)
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

