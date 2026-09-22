import SwiftUI

struct IngredientArt: View {
    let id: IngredientID

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                switch id {
                case .dough:
                    Circle().fill(Color(hex: 0xE8B15A)).overlay(Circle().stroke(Color(hex: 0xC47A2B), lineWidth: 3))
                case .tomatoSauce, .tomato:
                    Circle().fill(Color(hex: 0xE53935))
                    Circle().fill(Color(hex: 0xC62828)).frame(width: s * 0.35, height: s * 0.35)
                case .cheese:
                    RoundedRectangle(cornerRadius: 6).fill(Color(hex: 0xFFE14A))
                    Circle().fill(Color(hex: 0xF4C400).opacity(0.5)).frame(width: s * 0.18, height: s * 0.18).offset(x: s * 0.12, y: -s * 0.08)
                case .pepperoni:
                    Circle().fill(Color(hex: 0xC62828))
                    Circle().fill(Color(hex: 0xFF8A80).opacity(0.35)).frame(width: s * 0.3, height: s * 0.3)
                case .mushroom:
                    MushroomBite().scaleEffect(1.6)
                case .pineapple:
                    RoundedRectangle(cornerRadius: 6).fill(Color(hex: 0xFFE14A))
                    Capsule().fill(Color(hex: 0x7ED957)).frame(width: 8, height: 16).offset(y: -s * 0.28)
                case .bun, .topBun, .bread, .topBread:
                    Capsule().fill(Color(hex: 0xF6C56A))
                case .patty:
                    Capsule().fill(Color(hex: 0x6D4C41)).frame(width: s * 0.78, height: s * 0.42)
                case .lettuce:
                    Capsule().fill(Color(hex: 0x7ED957))
                case .onion:
                    Circle().stroke(Color(hex: 0xE1BEE7), lineWidth: 6).padding(10)
                case .cone:
                    Triangle().fill(Color(hex: 0xE09A3A)).frame(width: s * 0.5, height: s * 0.62).offset(y: s * 0.08)
                case .vanilla, .vanillaFrosting, .scoop:
                    Circle().fill(Color(hex: 0xFFF4C8))
                case .strawberry, .strawberryFrosting:
                    Circle().fill(Color(hex: 0xFF9BC8))
                case .chocolate, .chocolateFrosting:
                    Circle().fill(Color(hex: 0x6D4C41))
                case .mint:
                    Circle().fill(Color(hex: 0x80E8C0))
                case .sprinkles, .rainbowCandy:
                    ZStack {
                        ForEach(0..<6, id: \.self) { i in
                            Capsule()
                                .fill([Color.red, Color.yellow, Color.blue, Color.green, Color.pink, Color.orange][i])
                                .frame(width: 10, height: 4)
                                .offset(y: -12)
                                .rotationEffect(.degrees(Double(i) / 6 * 360))
                        }
                    }
                case .cherry:
                    Circle().fill(Color(hex: 0xE53935)).frame(width: s * 0.45, height: s * 0.45)
                case .donutBase:
                    DonutArt(placed: [.donutBase, .strawberryFrosting]).scaleEffect(0.86)
                case .ham:
                    Capsule().fill(Color(hex: 0xE57373)).frame(width: s * 0.78, height: s * 0.36)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .accessibilityHidden(true)
    }
}
