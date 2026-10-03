import SwiftUI

enum Brand {
    static let name = "Kido Chef"
    static let tagline = "Cook • Mix • Create • Have Fun!"
    static let company = "Sai Laksha Technologies"
    static let studio = "sreeo"
    static let developer = "Sreedhar Lakshmanan"
    static let copyright = "© 2026 Sai Laksha Technologies"
    static let supportURL = URL(string: "https://sreedharlakshman2.github.io/CrazyFoodFactory/")!
    static let privacyURL = URL(string: "https://sreedharlakshman2.github.io/CrazyFoodFactory/privacy.html")!
    static let cream = Color(red: 1, green: 0.973, blue: 0.933)
    static let tiles: [Color] = [.cyan, .purple, .pink, .orange]
    static let wordmark = LinearGradient(
        colors: [.cyan, .purple, .pink, .orange],
        startPoint: .leading,
        endPoint: .trailing
    )
}
