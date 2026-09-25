import SwiftUI

enum GameTheme {
    static let factoryBlue = Color(hex: 0x4EC3FF)
    static let factoryMidBlue = Color(hex: 0x7AD4FF)
    static let factoryLightBlue = Color(hex: 0xC8F0FF)
    static let factorySkyTop = Color(hex: 0x2EB0FF)
    static let factorySkyBottom = Color(hex: 0xFFE9F4)
    static let primaryYellow = Color(hex: 0xFFD23F)
    static let orange = Color(hex: 0xFF9A3C)
    static let pizzaRed = Color(hex: 0xFF5A4E)
    static let burgerOrange = Color(hex: 0xF4B04A)
    static let iceCreamPink = Color(hex: 0xF3B7FF)
    static let donutPink = Color(hex: 0xFF8AD4)
    static let sandwichGreen = Color(hex: 0x7EE08A)
    static let successGreen = Color(hex: 0x2ECC71)
    static let playGreen = Color(hex: 0x27D36A)
    static let playGreenDeep = Color(hex: 0x17B054)
    static let dangerRed = Color(hex: 0xF04343)
    static let comicRed = Color(hex: 0xE53935)
    static let creamBackground = Color(hex: 0xFFF8E8)
    static let darkText = Color(hex: 0x1E3A5F)
    static let navy = Color(hex: 0x16345C)
    static let white = Color.white
    static let cardStroke = Color.white.opacity(0.85)
    static let lockBlue = Color(hex: 0x8BB7D6)

    static let titleGradient = LinearGradient(
        colors: [Color(hex: 0xFFE14A), Color(hex: 0xFF8A3D), Color(hex: 0xFF4D6A)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let playGradient = LinearGradient(
        colors: [Color(hex: 0x49E57D), Color(hex: 0x1DB954)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let skyGradient = LinearGradient(
        colors: [Color(hex: 0x7AD4FF), Color(hex: 0xB8EBFF), Color(hex: 0xEAF7FF)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let resultGradient = LinearGradient(
        colors: [Color(hex: 0x7AD4FF), Color(hex: 0xFFE7A8), Color(hex: 0xFFD0F0)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let celebrateGradient = LinearGradient(
        colors: [Color(hex: 0x5CC8FF), Color(hex: 0xFFE14A), Color(hex: 0xFFB6E8)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardRadius: CGFloat = 28
    static let buttonRadius: CGFloat = 22
    static let smallRadius: CGFloat = 16
    static let minTap: CGFloat = 60
}

enum GameFont {
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func title(_ size: CGFloat = 30) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func headline(_ size: CGFloat = 20) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func body(_ size: CGFloat = 17) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func caption(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}

struct PressScaleStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.95

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.58), value: configuration.isPressed)
    }
}

struct SoftCardShadow: ViewModifier {
    var opacity: Double = 0.14

    func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: 0x1E3A5F).opacity(opacity), radius: 12, x: 0, y: 8)
    }
}

extension View {
    func softCardShadow(_ opacity: Double = 0.14) -> some View {
        modifier(SoftCardShadow(opacity: opacity))
    }

    func factoryCard(radius: CGFloat = GameTheme.cardRadius) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.7), lineWidth: 3)
            )
            .softCardShadow()
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
