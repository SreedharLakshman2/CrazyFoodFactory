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
                    colors: [Color(hex: 0x7AD4FF), Color(hex: 0xB8EBFF), Color(hex: 0xEAF7FF)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                HStack(spacing: 14) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.white.opacity(0.42))
                            .frame(width: w * 0.15, height: 28)
                    }
                }
                .offset(y: compact ? -h * 0.37 : -h * 0.39)

                Capsule()
                    .fill(Color(hex: 0x90CAF9).opacity(0.7))
                    .frame(width: 22, height: h * 0.22)
                    .offset(x: -w * 0.43, y: -h * 0.12)
                Capsule()
                    .fill(Color(hex: 0x81D4FA).opacity(0.55))
                    .frame(width: 16, height: h * 0.14)
                    .offset(x: w * 0.44, y: -h * 0.18)

                if busy {
                    SteamPuffs()
                        .frame(width: 80, height: 70)
                        .offset(x: -w * 0.4, y: -h * 0.28)
                }

                VStack {
                    Spacer()
                    Ellipse()
                        .fill(Color.white.opacity(0.88))
                        .frame(width: w * 1.35, height: h * 0.30)
                        .offset(y: 28)
                }
            }
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

struct SteamPuffs: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    let phase = (t + Double(i) * 0.45).truncatingRemainder(dividingBy: 2.2) / 2.2
                    Circle()
                        .fill(Color.white.opacity(0.55 * (1 - phase)))
                        .frame(width: 16 + CGFloat(i) * 8, height: 16 + CGFloat(i) * 8)
                        .offset(x: CGFloat(i) * 8, y: -CGFloat(phase) * 46)
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
                FoodIllustrationView(food: .pizza, size: 72)
                    .offset(x: geo.size.width * 0.06, y: geo.size.height * 0.58 + CGFloat(sin(t) * 5))
                FoodIllustrationView(food: .burger, size: 64)
                    .offset(x: geo.size.width * 0.08, y: geo.size.height * 0.74 + CGFloat(cos(t * 1.1) * 4))
                FoodIllustrationView(food: .donut, size: 62)
                    .offset(x: geo.size.width * 0.76, y: geo.size.height * 0.70 + CGFloat(cos(t * 1.2) * 6))
                FoodIllustrationView(food: .iceCream, size: 70)
                    .offset(x: geo.size.width * 0.74, y: geo.size.height * 0.42 + CGFloat(sin(t * 1.3) * 5))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview {
    FactoryBackground()
}
