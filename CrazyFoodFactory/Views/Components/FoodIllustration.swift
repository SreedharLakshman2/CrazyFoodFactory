import SwiftUI

struct FoodIllustrationView: View {
    let food: FoodType
    var placed: [IngredientID] = []
    var melted: Bool = false
    var size: CGFloat = 180
    var cuteFace: Bool = false

    var body: some View {
        Group {
            switch food {
            case .pizza:
                PizzaArt(placed: placed.isEmpty ? [.dough, .tomatoSauce, .cheese] : placed)
            case .burger:
                BurgerArt(placed: placed.isEmpty ? [.bun, .patty, .cheese, .lettuce, .topBun] : placed, cuteFace: cuteFace || placed.contains(.topBun))
            case .iceCream:
                if melted {
                    MeltedIceCreamArt()
                } else {
                    IceCreamArt(placed: placed.isEmpty ? [.cone, .vanilla, .strawberry, .sprinkles] : placed)
                }
            case .donut:
                DonutArt(placed: placed.isEmpty ? [.donutBase, .strawberryFrosting, .sprinkles] : placed)
            case .sandwich:
                SandwichArt(placed: placed.isEmpty ? [.bread, .lettuce, .tomato, .cheese, .ham, .topBread] : placed)
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(food.displayName)
    }
}

struct PizzaArt: View {
    var placed: [IngredientID]

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                Ellipse()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: s * 0.86, height: s * 0.16)
                    .offset(y: s * 0.38)
                Circle()
                    .fill(
                        LinearGradient(colors: [Color(hex: 0xE8B15A), Color(hex: 0xC47A2B)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(Circle().stroke(Color(hex: 0xA65C1E), lineWidth: s * 0.03))
                    .frame(width: s * 0.92, height: s * 0.92)
                if placed.contains(.tomatoSauce) || placed.contains(.dough) {
                    Circle()
                        .fill(Color(hex: 0xE24A3B))
                        .frame(width: s * 0.74, height: s * 0.74)
                }
                if placed.contains(.cheese) {
                    cheeseBlobs(s)
                }
                if placed.contains(.pepperoni) {
                    ForEach(pepperoniPoints, id: \.self) { p in
                        Circle()
                            .fill(Color(hex: 0xC62828))
                            .overlay(Circle().fill(Color(hex: 0xFF8A80).opacity(0.3)).padding(3))
                            .frame(width: s * 0.13, height: s * 0.13)
                            .offset(x: s * p.x, y: s * p.y)
                    }
                }
                if placed.contains(.mushroom) {
                    ForEach(mushroomPoints, id: \.self) { p in
                        MushroomBite()
                            .frame(width: s * 0.14, height: s * 0.12)
                            .offset(x: s * p.x, y: s * p.y)
                    }
                }
                if placed.contains(.pineapple) {
                    ForEach(Array(pineapplePoints.enumerated()), id: \.offset) { _, p in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: 0xFFE14A))
                            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: 0xF4B400), lineWidth: 1))
                            .frame(width: s * 0.12, height: s * 0.08)
                            .rotationEffect(.degrees(p.z))
                            .offset(x: s * p.x, y: s * p.y)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var pepperoniPoints: [CGPoint] {
        [CGPoint(x: -0.16, y: -0.12), CGPoint(x: 0.18, y: -0.08), CGPoint(x: -0.02, y: 0.16), CGPoint(x: 0.14, y: 0.12), CGPoint(x: -0.2, y: 0.08)]
    }

    private var mushroomPoints: [CGPoint] {
        [CGPoint(x: 0.08, y: -0.2), CGPoint(x: -0.18, y: 0.18)]
    }

    private var pineapplePoints: [(x: CGFloat, y: CGFloat, z: Double)] {
        [(-0.1, 0.02, 20), (0.16, 0.18, -15), (0.02, -0.18, 40), (-0.22, -0.06, 10)]
    }

    private func cheeseBlobs(_ s: CGFloat) -> some View {
        ZStack {
            ForEach(0..<7, id: \.self) { i in
                Capsule()
                    .fill(Color(hex: 0xFFE9A0).opacity(0.95))
                    .frame(width: s * 0.18, height: s * 0.08)
                    .rotationEffect(.degrees(Double(i) * 26))
                    .offset(y: s * 0.08)
            }
        }
    }
}

struct BurgerArt: View {
    var placed: [IngredientID]
    var cuteFace: Bool

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            VStack(spacing: -s * 0.035) {
                if placed.contains(.topBun) {
                    bun(s, top: true)
                        .overlay {
                            if cuteFace { face(s) }
                        }
                }
                if placed.contains(.lettuce) {
                    lettuce(s)
                }
                if placed.contains(.cheese) {
                    cheese(s)
                }
                if placed.contains(.tomato) {
                    Capsule().fill(Color(hex: 0xE53935)).frame(width: s * 0.7, height: s * 0.07)
                }
                if placed.contains(.onion) {
                    Capsule().fill(Color(hex: 0xF3E5F5)).frame(width: s * 0.62, height: s * 0.05)
                }
                if placed.contains(.patty) {
                    Capsule()
                        .fill(LinearGradient(colors: [Color(hex: 0x8D4B2B), Color(hex: 0x5D2E13)], startPoint: .top, endPoint: .bottom))
                        .frame(width: s * 0.76, height: s * 0.16)
                }
                if placed.contains(.bun) || placed.contains(.topBun) {
                    bun(s, top: false)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .shadow(color: .black.opacity(0.12), radius: 8, y: 6)
        }
    }

    private func bun(_ s: CGFloat, top: Bool) -> some View {
        ZStack {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0xF6C56A), Color(hex: 0xE09A3A)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: s * 0.82, height: top ? s * 0.28 : s * 0.2)
            if top {
                ForEach(0..<7, id: \.self) { i in
                    Capsule()
                        .fill(Color(hex: 0xFFF3C4))
                        .frame(width: 7, height: 4)
                        .offset(x: CGFloat(i - 3) * s * 0.09, y: -s * 0.04)
                }
            }
        }
    }

    private func lettuce(_ s: CGFloat) -> some View {
        Capsule()
            .fill(Color(hex: 0x7ED957))
            .frame(width: s * 0.86, height: s * 0.1)
            .overlay(
                HStack(spacing: 6) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle().fill(Color(hex: 0x58C14A)).frame(width: 10, height: 10)
                    }
                }
            )
    }

    private func cheese(_ s: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: 0xFFE14A))
            .frame(width: s * 0.78, height: s * 0.08)
            .rotationEffect(.degrees(-4))
    }

    private func face(_ s: CGFloat) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: s * 0.16) {
                eye(s)
                eye(s)
            }
            Capsule().fill(Color(hex: 0xC62828)).frame(width: s * 0.16, height: 6)
        }
        .offset(y: s * 0.02)
    }

    private func eye(_ s: CGFloat) -> some View {
        ZStack {
            Circle().fill(Color.white).frame(width: s * 0.13, height: s * 0.14)
            Circle().fill(Color(hex: 0x3E2723)).frame(width: s * 0.07, height: s * 0.08)
            Circle().fill(Color.white).frame(width: 4, height: 4).offset(x: 2, y: -2)
        }
    }
}

struct IceCreamArt: View {
    var placed: [IngredientID]

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            VStack(spacing: -s * 0.06) {
                ZStack {
                    if placed.contains(.cherry) {
                        Circle().fill(Color(hex: 0xE53935)).frame(width: s * 0.12, height: s * 0.12).offset(y: -s * 0.22)
                    }
                    scoops(s)
                    if placed.contains(.sprinkles) {
                        sprinkles(s)
                    }
                }
                if placed.contains(.cone) {
                    cone(s)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private func scoops(_ s: CGFloat) -> some View {
        ZStack {
            if flavorCount >= 1 {
                Circle().fill(flavorColor(0)).frame(width: s * 0.42, height: s * 0.42).offset(x: -s * 0.08, y: s * 0.04)
            }
            if flavorCount >= 2 {
                Circle().fill(flavorColor(1)).frame(width: s * 0.4, height: s * 0.4).offset(x: s * 0.12, y: s * 0.02)
            }
            Circle().fill(flavorColor(0)).frame(width: s * 0.38, height: s * 0.38).offset(y: -s * 0.12)
        }
        .shadow(color: .black.opacity(0.08), radius: 4, y: 3)
    }

    private var flavors: [IngredientID] {
        placed.filter { [.vanilla, .strawberry, .chocolate, .mint, .scoop].contains($0) }
    }

    private var flavorCount: Int {
        max(placed.contains(.cone) && flavors.isEmpty ? 0 : flavors.count, placed.contains(where: { [.vanilla, .strawberry, .chocolate, .mint].contains($0) }) ? 1 : 0)
    }

    private func flavorColor(_ index: Int) -> Color {
        let id = flavors.indices.contains(index) ? flavors[index] : (flavors.first ?? .vanilla)
        switch id {
        case .strawberry: return Color(hex: 0xFF9BC8)
        case .chocolate: return Color(hex: 0x8D6E63)
        case .mint: return Color(hex: 0x80E8C0)
        default: return Color(hex: 0xFFF4C8)
        }
    }

    private func cone(_ s: CGFloat) -> some View {
        Triangle()
            .fill(
                LinearGradient(colors: [Color(hex: 0xF6C56A), Color(hex: 0xD18A2F)], startPoint: .top, endPoint: .bottom)
            )
            .overlay(
                Triangle().stroke(Color(hex: 0xB87422), lineWidth: 1)
            )
            .frame(width: s * 0.38, height: s * 0.42)
    }

    private func sprinkles(_ s: CGFloat) -> some View {
        ZStack {
            ForEach(0..<10, id: \.self) { i in
                Capsule()
                    .fill([Color(hex: 0xFF5A8A), Color(hex: 0x4FC3F7), Color(hex: 0xFFE14A), Color(hex: 0x7ED957)][i % 4])
                    .frame(width: 8, height: 3)
                    .rotationEffect(.degrees(Double(i) * 28))
                    .offset(x: CGFloat((i % 5) - 2) * 12, y: CGFloat((i / 5) * 14) - 20)
            }
        }
    }
}

struct MeltedIceCreamArt: View {
    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                Ellipse()
                    .fill(Color(hex: 0xF48FB1))
                    .frame(width: s * 0.86, height: s * 0.34)
                    .offset(y: s * 0.16)
                Circle()
                    .fill(Color(hex: 0xF8BBD0))
                    .frame(width: s * 0.5, height: s * 0.42)
                    .offset(y: -s * 0.02)
                VStack(spacing: 6) {
                    HStack(spacing: 16) {
                        Capsule().fill(Color(hex: 0x4A2C2A)).frame(width: 16, height: 6)
                        Capsule().fill(Color(hex: 0x4A2C2A)).frame(width: 16, height: 6)
                    }
                    Capsule().fill(Color(hex: 0xC62828)).frame(width: 18, height: 6)
                }
                .offset(y: -s * 0.02)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct DonutArt: View {
    var placed: [IngredientID]

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: 0xE8B15A), Color(hex: 0xC47A2B)], startPoint: .top, endPoint: .bottom))
                    .frame(width: s * 0.86, height: s * 0.86)
                Circle()
                    .fill(frosting)
                    .frame(width: s * 0.78, height: s * 0.78)
                dripRing(s)
                Circle()
                    .fill(Color(hex: 0xC8F0FF))
                    .frame(width: s * 0.28, height: s * 0.28)
                Circle()
                    .stroke(Color(hex: 0xA65C1E), lineWidth: 3)
                    .frame(width: s * 0.3, height: s * 0.3)
                if placed.contains(.sprinkles) || placed.contains(.rainbowCandy) {
                    ForEach(0..<14, id: \.self) { i in
                        Capsule()
                            .fill([GameTheme.pizzaRed, GameTheme.primaryYellow, Color(hex: 0x4FC3F7), Color(hex: 0x7ED957), GameTheme.donutPink][i % 5])
                            .frame(width: 10, height: 4)
                            .offset(y: -s * 0.28)
                            .rotationEffect(.degrees(Double(i) / 14 * 360))
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var frosting: Color {
        if placed.contains(.chocolateFrosting) { return Color(hex: 0x6D4C41) }
        if placed.contains(.vanillaFrosting) { return Color(hex: 0xFFF4C8) }
        return Color(hex: 0xFF8AD4)
    }

    private func dripRing(_ s: CGFloat) -> some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Capsule()
                    .fill(frosting)
                    .frame(width: s * 0.1, height: s * 0.16)
                    .offset(y: s * 0.34)
                    .rotationEffect(.degrees(Double(i) / 8 * 360))
            }
        }
    }
}

struct SandwichArt: View {
    var placed: [IngredientID]

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            VStack(spacing: -s * 0.02) {
                if placed.contains(.topBread) { bread(s) }
                if placed.contains(.ham) { Capsule().fill(Color(hex: 0xE57373)).frame(width: s * 0.74, height: s * 0.09) }
                if placed.contains(.cheese) { RoundedRectangle(cornerRadius: 3).fill(Color(hex: 0xFFE14A)).frame(width: s * 0.76, height: s * 0.07) }
                if placed.contains(.tomato) { Capsule().fill(Color(hex: 0xE53935)).frame(width: s * 0.7, height: s * 0.07) }
                if placed.contains(.lettuce) { Capsule().fill(Color(hex: 0x7ED957)).frame(width: s * 0.8, height: s * 0.08) }
                if placed.contains(.onion) { Capsule().fill(Color(hex: 0xF3E5F5)).frame(width: s * 0.62, height: s * 0.05) }
                if placed.contains(.bread) { bread(s) }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
        }
    }

    private func bread(_ s: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: s * 0.08, style: .continuous)
            .fill(LinearGradient(colors: [Color(hex: 0xF8D48A), Color(hex: 0xE2A85A)], startPoint: .top, endPoint: .bottom))
            .frame(width: s * 0.84, height: s * 0.16)
            .overlay(
                RoundedRectangle(cornerRadius: s * 0.08, style: .continuous)
                    .stroke(Color(hex: 0xC47A2B), lineWidth: 2)
            )
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.closeSubpath()
        return p
    }
}

struct MushroomBite: View {
    var body: some View {
        VStack(spacing: -2) {
            Capsule().fill(Color(hex: 0xE8D7C3)).frame(width: 22, height: 12)
            Capsule().fill(Color(hex: 0xF5EDE3)).frame(width: 10, height: 10)
        }
    }
}

struct OvenArt: View {
    var glowing: Bool = false
    var meltedInside: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(hex: 0x455A64))
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(glowing ? Color(hex: 0xFF8A3D) : Color(hex: 0x263238))
                .padding(18)
                .overlay {
                    if meltedInside {
                        MeltedIceCreamArt().padding(28)
                    } else if glowing {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: 0xFFE14A).opacity(0.7))
                            .padding(28)
                    }
                }
            VStack {
                HStack {
                    Circle().fill(Color(hex: 0x90A4AE)).frame(width: 10, height: 10)
                    Spacer()
                    Circle().fill(Color(hex: 0x90A4AE)).frame(width: 10, height: 10)
                }
                .padding(10)
                Spacer()
            }
        }
        .shadow(color: glowing ? Color.orange.opacity(0.45) : .black.opacity(0.12), radius: glowing ? 16 : 8, y: 6)
        .accessibilityLabel(glowing ? "Hot oven" : "Oven")
    }
}

struct PenguinArt: View {
    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                Capsule().fill(Color(hex: 0x263238)).frame(width: s * 0.62, height: s * 0.86)
                Capsule().fill(Color.white).frame(width: s * 0.42, height: s * 0.58).offset(y: s * 0.08)
                Circle().fill(Color.white).frame(width: s * 0.46, height: s * 0.4).offset(y: -s * 0.22)
                HStack(spacing: s * 0.14) {
                    Circle().fill(Color(hex: 0x212121)).frame(width: s * 0.08, height: s * 0.08)
                    Circle().fill(Color(hex: 0x212121)).frame(width: s * 0.08, height: s * 0.08)
                }
                .offset(y: -s * 0.24)
                Triangle().fill(Color(hex: 0xFF9A3C)).frame(width: s * 0.16, height: s * 0.1).rotationEffect(.degrees(180)).offset(y: -s * 0.14)
                HStack(spacing: s * 0.18) {
                    Ellipse().fill(Color(hex: 0xFF9A3C)).frame(width: s * 0.16, height: s * 0.08)
                    Ellipse().fill(Color(hex: 0xFF9A3C)).frame(width: s * 0.16, height: s * 0.08)
                }
                .offset(y: s * 0.4)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .accessibilityLabel("Penguin visitor")
    }
}

#Preview {
    ScrollView {
        VStack {
            FoodIllustrationView(food: .pizza, size: 160)
            FoodIllustrationView(food: .burger, size: 160, cuteFace: true)
            FoodIllustrationView(food: .iceCream, size: 160)
            FoodIllustrationView(food: .donut, size: 160)
            FoodIllustrationView(food: .sandwich, size: 160)
        }
        .padding()
        .background(GameTheme.factoryLightBlue)
    }
}
