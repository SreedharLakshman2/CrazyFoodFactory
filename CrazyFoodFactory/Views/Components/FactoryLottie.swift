import SwiftUI
#if canImport(Lottie)
import Lottie
#endif

enum FactoryLottieName: String {
    case yumStars = "yum_stars"
    case yumHearts = "yum_hearts"
    case sprinkleRain = "sprinkle_rain"
    case foodParade = "food_parade"
    case yumBurst = "yum_burst"
}

struct FactoryLottie: View {
    let name: FactoryLottieName
    var loop: Bool = true

    var body: some View {
        #if canImport(Lottie)
        if let animation = LottieAnimation.named(name.rawValue, subdirectory: "Lottie")
            ?? LottieAnimation.named(name.rawValue) {
            LottieView(animation: animation)
                .playing(loopMode: loop ? .loop : .playOnce)
                .resizable()
        } else {
            KidMotionFallback(kind: name)
        }
        #else
        KidMotionFallback(kind: name)
        #endif
    }
}

struct KidMotionFallback: View {
    let kind: FactoryLottieName

    var body: some View {
        switch kind {
        case .foodParade:
            YummyFoodParade()
        case .yumBurst:
            YumBurstMotion()
        default:
            fallingBits
        }
    }

    private var fallingBits: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<10, id: \.self) { i in
                        let phase = (t * speed + Double(i) * 0.16).truncatingRemainder(dividingBy: 1)
                        shape(i)
                            .font(.system(size: 16 + CGFloat(i % 4) * 6, weight: .bold))
                            .frame(width: 16 + CGFloat(i % 3) * 6, height: 14 + CGFloat(i % 2) * 5)
                            .offset(
                                x: geo.size.width * (0.08 + CGFloat(i) * 0.09),
                                y: geo.size.height * (1 - CGFloat(phase))
                            )
                            .opacity(1 - phase)
                            .rotationEffect(.degrees(phase * 80))
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var speed: Double {
        kind == .sprinkleRain ? 0.55 : 0.35
    }

    @ViewBuilder
    private func shape(_ i: Int) -> some View {
        let colors: [Color] = [
            Color(hex: 0xFFD23F), Color(hex: 0xFF6AD5), Color(hex: 0x4EC3FF),
            Color(hex: 0x49E57D), Color(hex: 0xFF5A4E), Color(hex: 0xFF9A3C)
        ]
        switch kind {
        case .yumHearts:
            Image(systemName: "heart.fill").foregroundColor(colors[i % colors.count])
        case .sprinkleRain:
            Capsule().fill(colors[i % colors.count])
        default:
            Image(systemName: "sparkle").foregroundColor(colors[i % colors.count])
        }
    }
}

struct YummyFoodParade: View {
    private let foods: [FoodType] = [.pizza, .dosa, .taco, .biryani, .burger, .burrito, .cupcake, .mangoLassi, .ramen, .donut]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { geo in
                ZStack {
                    ForEach(Array(foods.enumerated()), id: \.element) { index, food in
                        let wave = sin(t * 1.4 + Double(index) * 0.7)
                        let drift = cos(t * 0.9 + Double(index) * 0.5)
                        FoodIllustrationView(food: food, size: index.isMultiple(of: 2) ? 58 : 50)
                            .rotationEffect(.degrees(wave * 8))
                            .offset(
                                x: geo.size.width * (0.08 + CGFloat(index % 5) * 0.18) + CGFloat(drift) * 8,
                                y: geo.size.height * (0.18 + CGFloat(index / 5) * 0.42) + CGFloat(wave) * 10
                            )
                    }
                    ForEach(0..<6, id: \.self) { i in
                        Image(systemName: i.isMultiple(of: 2) ? "heart.fill" : "sparkle")
                            .font(.system(size: 12 + CGFloat(i % 3) * 4, weight: .bold))
                            .foregroundColor([Color(hex: 0xFF6AD5), Color(hex: 0xFFD23F), Color(hex: 0xFF5A4E)][i % 3])
                            .offset(
                                x: geo.size.width * (0.12 + CGFloat(i) * 0.14),
                                y: geo.size.height * (0.12 + CGFloat((sin(t * 1.6 + Double(i)) + 1) / 2) * 0.7)
                            )
                            .opacity(0.85)
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct YumBurstMotion: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                Text("YUM!")
                    .font(GameFont.display(42))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: 0xFFE14A), Color(hex: 0xFF6AD5), Color(hex: 0xFF5A4E)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(1 + 0.06 * sin(t * 4))
                    .shadow(color: Color.white.opacity(0.8), radius: 0, y: 2)
                ForEach(0..<8, id: \.self) { i in
                    Image(systemName: i.isMultiple(of: 2) ? "heart.fill" : "fork.knife")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor([Color(hex: 0xFF6AD5), Color(hex: 0xFFD23F), Color(hex: 0x49E57D), Color(hex: 0x4EC3FF)][i % 4])
                        .offset(
                            x: cos(t * 1.8 + Double(i)) * 70,
                            y: sin(t * 1.8 + Double(i)) * 46
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
