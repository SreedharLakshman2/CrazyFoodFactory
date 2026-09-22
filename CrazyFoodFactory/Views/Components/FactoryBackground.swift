import SwiftUI

struct FactoryBackground: View {
    var busy: Bool = true
    var compact: Bool = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(
                    colors: [Color(hex: 0x3DB7FF), Color(hex: 0x7AD4FF), Color(hex: 0xE8F8FF)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                RadialGradient(colors: [Color.white.opacity(0.4), .clear], center: .top, startRadius: 10, endRadius: h * 0.4)

                windowRow(width: w)
                    .offset(y: compact ? -h * 0.34 : -h * 0.36)

                colorfulPipe(color: Color(hex: 0x90CAF9), joint: Color(hex: 0x64B5F6))
                    .frame(width: w * 0.14, height: h * 0.26)
                    .offset(x: -w * 0.42, y: -h * 0.12)

                colorfulPipe(color: Color(hex: 0xFFCC80), joint: Color(hex: 0xFFB74D))
                    .frame(width: w * 0.12, height: h * 0.2)
                    .offset(x: w * 0.43, y: -h * 0.2)

                machineBox(color: Color(hex: 0x81D4FA), accent: Color(hex: 0x29B6F6))
                    .frame(width: 54, height: 44)
                    .offset(x: -w * 0.36, y: h * 0.08)

                machineBox(color: Color(hex: 0xF8BBD0), accent: Color(hex: 0xF06292))
                    .frame(width: 48, height: 40)
                    .offset(x: w * 0.36, y: h * 0.14)

                if busy {
                    SteamPuffs()
                        .frame(width: w * 0.28, height: h * 0.18)
                        .offset(x: -w * 0.4, y: -h * 0.28)
                    SteamPuffs()
                        .frame(width: w * 0.22, height: h * 0.14)
                        .offset(x: w * 0.4, y: -h * 0.32)
                    ConveyorBelt()
                        .frame(height: compact ? 58 : 74)
                        .padding(.horizontal, 10)
                        .offset(y: h * 0.43)
                }

                VStack {
                    Spacer()
                    Ellipse()
                        .fill(Color.white.opacity(0.42))
                        .frame(width: w * 1.25, height: h * 0.26)
                        .offset(y: 20)
                }
            }
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private func windowRow(width: CGFloat) -> some View {
        HStack(spacing: 14) {
            ForEach(0..<3, id: \.self) { i in
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(colors: [Color.white.opacity(0.55), Color.white.opacity(0.22)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: width * 0.18, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.7), lineWidth: 2)
                    )
                    .overlay(
                        Rectangle().fill(Color.white.opacity(0.25)).frame(width: 2)
                    )
            }
        }
    }

    private func colorfulPipe(color: Color, joint: Color) -> some View {
        VStack(spacing: -4) {
            Capsule().fill(joint).frame(height: 20)
            RoundedRectangle(cornerRadius: 10).fill(color)
            Capsule().fill(joint).frame(height: 22)
                .overlay(Capsule().fill(Color.white.opacity(0.28)).padding(5))
        }
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }

    private func machineBox(color: Color, accent: Color) -> some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(LinearGradient(colors: [color, accent], startPoint: .top, endPoint: .bottom))
            .overlay(
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Circle().fill(Color.white.opacity(0.8)).frame(width: 7, height: 7)
                        Circle().fill(Color.yellow.opacity(0.9)).frame(width: 7, height: 7)
                    }
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.35)).frame(height: 10)
                }
                .padding(8)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, y: 3)
    }
}

struct ConveyorBelt: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let shift = CGFloat(t.truncatingRemainder(dividingBy: 1.1)) / 1.1
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(colors: [Color(hex: 0x607D8B), Color(hex: 0x455A64)], startPoint: .top, endPoint: .bottom))
                HStack(spacing: 14) {
                    ForEach(0..<10, id: \.self) { _ in
                        Capsule().fill(Color(hex: 0x90A4AE)).frame(width: 24, height: 9)
                    }
                }
                .offset(x: -24 + shift * 38)
                HStack {
                    Circle().fill(Color(hex: 0x37474F)).frame(width: 18, height: 18)
                    Spacer()
                    Circle().fill(Color(hex: 0x37474F)).frame(width: 18, height: 18)
                }
                .padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(hex: 0x263238), lineWidth: 3)
            )
        }
    }
}

struct SteamPuffs: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(0..<4, id: \.self) { i in
                    let phase = (t + Double(i) * 0.4).truncatingRemainder(dividingBy: 2.4) / 2.4
                    Circle()
                        .fill(Color.white.opacity(0.6 * (1 - phase)))
                        .frame(width: 18 + CGFloat(i) * 7, height: 18 + CGFloat(i) * 7)
                        .offset(x: CGFloat(i) * 9, y: -CGFloat(phase) * 54)
                }
            }
        }
    }
}

struct FloatingFoods: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { geo in
                FoodIllustrationView(food: .pizza, placed: [.dough, .tomatoSauce, .cheese, .pepperoni], size: 78)
                    .offset(x: geo.size.width * 0.04, y: geo.size.height * 0.54 + CGFloat(sin(t) * 6))
                FoodIllustrationView(food: .burger, placed: [.bun, .patty, .cheese, .topBun], size: 70)
                    .offset(x: geo.size.width * 0.06, y: geo.size.height * 0.72 + CGFloat(cos(t * 1.1) * 5))
                FoodIllustrationView(food: .donut, size: 68)
                    .offset(x: geo.size.width * 0.74, y: geo.size.height * 0.68 + CGFloat(cos(t * 1.2) * 7))
                FoodIllustrationView(food: .iceCream, placed: [.cone, .strawberry, .sprinkles], size: 74)
                    .offset(x: geo.size.width * 0.72, y: geo.size.height * 0.40 + CGFloat(sin(t * 1.4) * 5))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview {
    FactoryBackground()
}
