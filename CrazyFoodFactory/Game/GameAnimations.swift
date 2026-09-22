import SwiftUI

enum GameAnimations {
    static let bounce = Animation.spring(response: 0.38, dampingFraction: 0.52)
    static let pulse = Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true)
    static let slideIn = Animation.spring(response: 0.46, dampingFraction: 0.82)
    static let successPop = Animation.spring(response: 0.42, dampingFraction: 0.56)
    static let errorWobble = Animation.spring(response: 0.22, dampingFraction: 0.28)
    static let ingredientFly = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let foodSpin = Animation.easeInOut(duration: 0.7)
    static let chefReaction = Animation.spring(response: 0.34, dampingFraction: 0.6)
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat
    var shakes: CGFloat
    var animatableData: CGFloat

    init(amount: CGFloat = 8, shakes: CGFloat = 3, animatableData: CGFloat) {
        self.amount = amount
        self.shakes = shakes
        self.animatableData = animatableData
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * shakes)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

struct PulseModifier: ViewModifier {
    var active: Bool
    @State private var on = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(active && on ? 1.08 : 1)
            .onAppear {
                guard active else { return }
                withAnimation(GameAnimations.pulse) { on = true }
            }
            .onChange(of: active) { _, value in
                if value {
                    withAnimation(GameAnimations.pulse) { on = true }
                } else {
                    on = false
                }
            }
    }
}

extension View {
    func bounceOn(_ trigger: Bool) -> some View {
        scaleEffect(trigger ? 1.12 : 1)
            .animation(GameAnimations.bounce, value: trigger)
    }

    func pulsing(_ active: Bool) -> some View {
        modifier(PulseModifier(active: active))
    }
}
