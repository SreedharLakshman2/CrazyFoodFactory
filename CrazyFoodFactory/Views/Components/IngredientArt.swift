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
                case .bun, .topBun, .hotdogBun:
                    clayBun(s)
                case .bread, .topBread:
                    clayBread(s)
                case .patty:
                    clayLoaf(s * 0.92, Color(hex: 0x7A4A2E), Color(hex: 0x4E2C18), seeds: false)
                case .lettuce:
                    clayLeaf(s, Color(hex: 0x8BE06A), Color(hex: 0x3D8B40))
                case .onion:
                    clayOnion(s)
                case .cone:
                    Triangle()
                        .fill(LinearGradient(colors: [Color(hex: 0xF0B35A), Color(hex: 0xC87A28)], startPoint: .top, endPoint: .bottom))
                        .frame(width: s * 0.52, height: s * 0.68)
                        .shadow(color: Color.black.opacity(0.12), radius: 3, y: 2)
                case .vanilla, .vanillaFrosting, .scoop:
                    clayCircle(s, Color(hex: 0xFFF4C8), Color(hex: 0xE8D48A))
                case .strawberry, .strawberryFrosting:
                    clayCircle(s, Color(hex: 0xFF9BC8), Color(hex: 0xE85A96))
                case .chocolate, .chocolateFrosting:
                    clayCircle(s, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
                case .mint:
                    clayCircle(s, Color(hex: 0x80E8C0), Color(hex: 0x2DB88A))
                case .sprinkles, .rainbowCandy:
                    claySprinkles(s)
                case .cherry:
                    clayCircle(s * 0.55, Color(hex: 0xE53935), Color(hex: 0xB71C1C))
                case .donutBase:
                    ArtImage(name: "ArtDonut")
                case .ham:
                    clayLoaf(s * 0.9, Color(hex: 0xF48A8A), Color(hex: 0xD45A5A), seeds: false)
                case .tortilla:
                    clayCircle(s, Color(hex: 0xF0C56A), Color(hex: 0xD49A3A))
                case .tacoBeef:
                    clayCrumble(s)
                case .meatball:
                    clayCircle(s * 0.86, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
                case .sausage:
                    claySausage(s)
                case .salsa, .ketchup:
                    clayBlob(s, Color(hex: 0xFF6B5A), Color(hex: 0xC62828))
                case .avocado:
                    clayAvocado(s)
                case .noodles:
                    clayNoodles(s)
                case .basil:
                    clayLeaf(s * 0.86, Color(hex: 0x66BB6A), Color(hex: 0x2E7D32))
                case .cupcakeBase:
                    clayCupcake(s)
                case .cupcakeFrosting:
                    clayCircle(s, Color(hex: 0xFF9BC8), Color(hex: 0xE85A96))
                case .candle:
                    clayCandle(s)
                case .mustard:
                    clayBlob(s, Color(hex: 0xFFE14A), Color(hex: 0xF4B400))
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
                    colors: [Color.white.opacity(0.7), light, dark],
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
                .fill(LinearGradient(colors: [light, dark], startPoint: .top, endPoint: .bottom))
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

    private func clayBun(_ size: CGFloat) -> some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(colors: [Color(hex: 0xF6D08A), Color(hex: 0xD89A3C)], startPoint: .top, endPoint: .bottom))
                .frame(width: size * 0.9, height: size * 0.52)
                .shadow(color: Color.black.opacity(0.14), radius: 3, y: 2)
            ForEach(0..<6, id: \.self) { i in
                Capsule()
                    .fill(Color(hex: 0xFFF6D0))
                    .frame(width: 6, height: 3)
                    .offset(x: CGFloat(i - 2) * 8 - 4, y: CGFloat(i % 2) * 6 - 6)
            }
        }
    }

    private func clayBread(_ size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size * 0.18, style: .continuous)
            .fill(LinearGradient(colors: [Color(hex: 0xF8E2B0), Color(hex: 0xE8B86A)], startPoint: .top, endPoint: .bottom))
            .frame(width: size * 0.86, height: size * 0.7)
            .overlay(
                RoundedRectangle(cornerRadius: size * 0.12, style: .continuous)
                    .fill(Color(hex: 0xFFF6D8))
                    .padding(.top, size * 0.1)
                    .padding(.horizontal, size * 0.1)
                    .padding(.bottom, size * 0.22)
            )
            .shadow(color: Color.black.opacity(0.12), radius: 3, y: 2)
    }

    private func clayLeaf(_ size: CGFloat, _ light: Color, _ dark: Color) -> some View {
        let leaf = Capsule()
            .fill(LinearGradient(colors: [light, dark], startPoint: .topLeading, endPoint: .bottomTrailing))
        return leaf
            .frame(width: size * 0.72, height: size * 0.42)
            .rotationEffect(.degrees(-18))
            .shadow(color: Color.black.opacity(0.12), radius: 3, y: 2)
    }

    private func clayOnion(_ size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [Color(hex: 0xF3E5F5), Color(hex: 0xCE93D8)], center: .center, startRadius: 2, endRadius: size * 0.4))
                .frame(width: size * 0.7, height: size * 0.7)
            Circle()
                .stroke(Color(hex: 0xE1BEE7), lineWidth: size * 0.06)
                .frame(width: size * 0.42, height: size * 0.42)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 3, y: 2)
    }

    private func claySprinkles(_ size: CGFloat) -> some View {
        ZStack {
            clayCircle(size * 0.9, Color(hex: 0xFFE0F0), Color(hex: 0xFF9AD0))
            ForEach(0..<7, id: \.self) { i in
                Capsule()
                    .fill([Color.red, Color.yellow, Color.blue, Color.green, Color.pink, Color.orange, Color.purple][i])
                    .frame(width: size * 0.16, height: size * 0.06)
                    .offset(y: -size * 0.22)
                    .rotationEffect(.degrees(Double(i) / 7 * 360))
            }
        }
    }

    private func clayCrumble(_ size: CGFloat) -> some View {
        ZStack {
            clayCircle(size * 0.42, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
                .offset(x: -size * 0.16, y: size * 0.08)
            clayCircle(size * 0.38, Color(hex: 0xA06A40), Color(hex: 0x6A4018))
                .offset(x: size * 0.14, y: -size * 0.04)
            clayCircle(size * 0.32, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
                .offset(y: size * 0.16)
        }
    }

    private func claySausage(_ size: CGFloat) -> some View {
        Capsule()
            .fill(LinearGradient(colors: [Color(hex: 0xB56A3A), Color(hex: 0x6A3418)], startPoint: .top, endPoint: .bottom))
            .frame(width: size * 0.9, height: size * 0.38)
            .shadow(color: Color.black.opacity(0.14), radius: 3, y: 2)
    }

    private func clayBlob(_ size: CGFloat, _ light: Color, _ dark: Color) -> some View {
        Capsule()
            .fill(RadialGradient(colors: [Color.white.opacity(0.55), light, dark], center: .init(x: 0.35, y: 0.3), startRadius: 1, endRadius: size * 0.4))
            .frame(width: size * 0.7, height: size * 0.56)
            .shadow(color: Color.black.opacity(0.12), radius: 3, y: 2)
    }

    private func clayAvocado(_ size: CGFloat) -> some View {
        ZStack {
            clayCircle(size, Color(hex: 0x9BE36A), Color(hex: 0x4CAF50))
            clayCircle(size * 0.38, Color(hex: 0x8D5A36), Color(hex: 0x5A3418))
        }
    }

    private func clayNoodles(_ size: CGFloat) -> some View {
        ZStack {
            ForEach(0..<4, id: \.self) { i in
                Capsule()
                    .fill(LinearGradient(colors: [Color(hex: 0xF6D56A), Color(hex: 0xE0A24A)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: size * 0.78, height: size * 0.1)
                    .offset(y: CGFloat(i - 1) * size * 0.14)
                    .rotationEffect(.degrees(Double(i) * 8 - 12))
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)
    }

    private func clayCupcake(_ size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: 0xF8D9A0), Color(hex: 0xE0A24A)], startPoint: .top, endPoint: .bottom))
                .frame(width: size * 0.56, height: size * 0.4)
                .offset(y: size * 0.16)
            clayCircle(size * 0.7, Color(hex: 0xFF9BC8), Color(hex: 0xE85A96))
                .offset(y: -size * 0.1)
        }
    }

    private func clayCandle(_ size: CGFloat) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color(hex: 0xFFD23F))
                .frame(width: size * 0.16, height: size * 0.16)
            Capsule()
                .fill(Color(hex: 0xFFF4C8))
                .frame(width: size * 0.14, height: size * 0.48)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)
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
