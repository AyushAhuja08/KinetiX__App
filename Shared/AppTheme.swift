

import SwiftUI
import UIKit

struct AppTheme {

    static let background = Color(uiColor: .systemBackground)
    static let cardBackground = Color(uiColor: .secondarySystemBackground)
    static let surfaceBackground = Color(uiColor: .tertiarySystemBackground)


    static let primaryAccent = Color(uiColor: .systemCyan)
    static let secondaryAccent = Color(uiColor: .systemTeal)


    static let primaryText = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    static let tertiaryText = Color(uiColor: .tertiaryLabel)


    static let blueCard = Color(uiColor: .systemBlue)
    static let orangeCard = Color(uiColor: .systemOrange)
    static let purpleCard = Color(uiColor: .systemPurple)
    static let greenCard = Color(uiColor: .systemGreen)


    static let headerGradient = LinearGradient(
        colors: [AppTheme.primaryAccent, AppTheme.secondaryAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [AppTheme.cardBackground, AppTheme.surfaceBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )


    static let cardShadow = Color(uiColor: .separator)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
