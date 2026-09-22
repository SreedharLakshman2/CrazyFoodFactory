import SwiftUI

struct IngredientArt: View {
    let id: IngredientID

    var body: some View {
        Group {
            if let name = GameArt.ingredient(id), GameArt.exists(name) {
                ArtImage(name: name)
            } else {
                fallback
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var fallback: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                switch id {
                case .dough:
                    clayCircle(s, Color(hex: 0xF6C56A), Color(hex: 0xE0A24A))
                case .bun, .topBun:
                    clayLoaf(s, Color(hex: 0xF4C56A), Color(hex: 0xD89A3C), seeds: true)
                case .bread, .topBread:
                    RoundedRectangle(cornerRadius: s * 0.18, style: .continuous)
                        .fill(LinearGradient(colors: [Color(hex: 0xF8E2B0), Color(hex: 0xE8B86A)], startPoint: .top, endPoint: .bottom))
                        .overlay(
                            RoundedRectangle(cornerRadius: s * 0.18, style: .continuous)
                                .fill(Color(hex: 0xFFF6D8).opacity(0.55))
                                .padding(.top, s * 0.08)
                                .padding(.horizontal, s * 0.08)
                                .padding(.bottom, s * 0.28)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 3, y: 2)
                case .patty:
                    clayLoaf(s * 0.92, Color(hex: 0x7A4A2E), Color(hex: 0x4E2C18), seeds: false)
                case .lettuce:
                    clayLoaf(s, Color(hex: 0x8BE06A), Color(hex: 0x4CAF50), seeds: false)
                        .scaleEffect(x: 1.05, y: 0.72)
                case .onion:
                    Circle()
                        .stroke(Color(hex: 0xE1BEE7), lineWidth: s * 0.12)
                        .padding(s * 0.18)
                case .cone:
                    Triangle()
                        .fill(LinearGradient(colors: [Color(hex: 0xF0B35A), Color(hex: 0xC87A28)], startPoint: .top, endPoint: .bottom))
                        .frame(width: s * 0.56, height: s * 0.7)
                        .overlay(
                            VStack(spacing: s * 0.08) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                                }
                            }
                            .padding(.horizontal, 8)
                        )
                case .vanilla, .vanillaFrosting, .scoop:
                    clayCircle(s, Color(hex: 0xFFF4C8), Color(hex: 0xE8D48A))
                case .strawberry, .strawberryFrosting:
                    clayCircle(s, Color(hex: 0xFF9BC8), Color(hex: 0xE85A96))
                case .chocolate, .chocolateFrosting:
                    clayCircle(s, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
                case .mint:
                    clayCircle(s, Color(hex: 0x80E8C0), Color(hex: 0x2DB88A))
                case .sprinkles, .rainbowCandy:
                    ZStack {
                        clayCircle(s * 0.9, Color(hex: 0xFFE0F0), Color(hex: 0xFF9AD0))
                        ForEach(0..<7, id: \.self) { i in
                            Capsule()
                                .fill([Color.red, Color.yellow, Color.blue, Color.green, Color.pink, Color.orange, Color.purple][i])
                                .frame(width: s * 0.16, height: s * 0.06)
                                .offset(y: -s * 0.22)
                                .rotationEffect(.degrees(Double(i) / 7 * 360))
                        }
                    }
                case .cherry:
                    clayCircle(s * 0.55, Color(hex: 0xE53935), Color(hex: 0xB71C1C))
                case .donutBase:
                    ArtImage(name: "ArtDonut")
                case .ham:
                    clayLoaf(s * 0.9, Color(hex: 0xF48A8A), Color(hex: 0xD45A5A), seeds: false)
                default:
                    clayCircle(s, id.trayColor, id.trayColor.opacity(0.75))
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private func clayCircle(_ size: CGFloat, _ light: Color, _ dark: Color) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.white.opacity(0.55), light, dark],
                    center: .init(x: 0.32, y: 0.28),
                    startRadius: 2,
                    endRadius: size * 0.62
                )
            )
            .frame(width: size * 0.86, height: size * 0.86)
            .shadow(color: Color.black.opacity(0.14), radius: 3, y: 2)
    }

    private func clayLoaf(_ size: CGFloat, _ light: Color, _ dark: Color, seeds: Bool) -> some View {
        ZStack {
            Capsule()
                .fill(
                    LinearGradient(colors: [light, dark], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size * 0.86, height: size * 0.48)
                .overlay(
                    Capsule()
                        .fill(Color.white.opacity(0.28))
                        .frame(width: size * 0.62, height: size * 0.12)
                        .offset(y: -size * 0.1)
                )
                .shadow(color: Color.black.opacity(0.14), radius: 3, y: 2)
            if seeds {
                ForEach(0..<5, id: \.self) { i in
                    Capsule()
                        .fill(Color(hex: 0xFFF3C8))
                        .frame(width: 5, height: 2)
                        .offset(x: CGFloat(i - 2) * 7, y: -2)
                }
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
