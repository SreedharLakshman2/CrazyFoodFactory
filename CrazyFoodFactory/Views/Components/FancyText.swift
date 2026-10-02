import SwiftUI

struct GradientHeadline: View {
    var text: String
    var size: CGFloat = 34
    var colors: [Color] = [Color(hex: 0xFFE14A), Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)]

    var body: some View {
        Text(text)
            .font(GameFont.display(size))
            .multilineTextAlignment(.center)
            .foregroundStyle(
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
            )
            .shadow(color: Color.white.opacity(0.7), radius: 0, y: 1)
            .shadow(color: Color(hex: 0x16345C).opacity(0.12), radius: 0, y: 3)
    }
}

struct AnimatedTextBanner: View {
    var text: String
    var colors: [Color] = [Color(hex: 0xFFE56A), Color(hex: 0xFF9A3C)]
    var textColor: Color = GameTheme.navy
    var size: CGFloat = 28

    @State private var shine = false
    @State private var bounce = false

    var body: some View {
        Text(text)
            .font(GameFont.display(size))
            .foregroundColor(textColor)
            .lineLimit(2)
            .minimumScaleFactor(0.65)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 26)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: shine ? .leading : .trailing,
                            endPoint: shine ? .trailing : .leading
                        )
                    )
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.9), lineWidth: 3)
            )
            .overlay(alignment: .top) {
                Capsule()
                    .fill(Color.white.opacity(0.35))
                    .frame(height: 10)
                    .padding(.horizontal, 28)
                    .padding(.top, 8)
            }
            .shadow(color: colors.last?.opacity(0.35) ?? Color.orange.opacity(0.3), radius: 0, y: 5)
            .scaleEffect(bounce ? 1.04 : 1)
            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: shine)
            .animation(.spring(response: 0.55, dampingFraction: 0.55).repeatForever(autoreverses: true), value: bounce)
            .onAppear {
                shine = true
                bounce = true
            }
            .accessibilityAddTraits(.isHeader)
    }
}

struct BrandWordmark: View {
    var large: Bool = true
    var scale: CGFloat = 1

    @State private var shine = false
    @State private var bounce = false

    private var kidoSize: CGFloat { (large ? 58 : 42) * scale }
    private var chefSize: CGFloat { (large ? 62 : 46) * scale }

    var body: some View {
        VStack(spacing: (large ? -6 : -3) * scale) {
            word("Kido", colors: [Color(hex: 0xFFFDF2), Color(hex: 0xFFE14A), Color(hex: 0xFFB300)], size: kidoSize)
            word("Chef", colors: [Color(hex: 0xFFF0C8), Color(hex: 0xFF7A28), Color(hex: 0xE02060)], size: chefSize)
        }
        .padding(.horizontal, (large ? 36 : 28) * scale)
        .padding(.vertical, (large ? 18 : 14) * scale)
        .background(plaque)
        .overlay(plaqueStroke)
        .overlay(alignment: .top) { gloss }
        .overlay(sparkles)
        .shadow(color: Color(hex: 0xFF8A3D).opacity(0.38), radius: 0, y: 6 * scale)
        .shadow(color: Color(hex: 0xFF5A8A).opacity(0.22), radius: 18 * scale, y: 10 * scale)
        .scaleEffect(bounce ? 1.03 : 1)
        .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: shine)
        .animation(.spring(response: 0.9, dampingFraction: 0.55).repeatForever(autoreverses: true), value: bounce)
        .onAppear {
            shine = true
            bounce = true
        }
        .accessibilityLabel(Brand.name)
        .accessibilityAddTraits(.isHeader)
    }

    private var plaque: some View {
        RoundedRectangle(cornerRadius: 34 * scale, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: 0xFFF7A0),
                        Color(hex: 0xFFD45C),
                        Color(hex: 0xFF9A4A),
                        Color(hex: 0xFF7AB8)
                    ],
                    startPoint: shine ? .topLeading : .bottomTrailing,
                    endPoint: shine ? .bottomTrailing : .topLeading
                )
            )
    }

    private var plaqueStroke: some View {
        RoundedRectangle(cornerRadius: 34 * scale, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [Color.white, Color.white.opacity(0.55), Color(hex: 0xFFE14A)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 4 * max(scale, 1)
            )
    }

    private var gloss: some View {
        Capsule()
            .fill(Color.white.opacity(0.42))
            .frame(height: 12 * scale)
            .padding(.horizontal, 28 * scale)
            .padding(.top, 10 * scale)
            .allowsHitTesting(false)
    }

    private var sparkles: some View {
        ZStack {
            Image(systemName: "sparkle")
                .font(.system(size: (large ? 16 : 13) * scale, weight: .bold))
                .foregroundColor(.white)
                .offset(x: (large ? -78 : -62) * scale, y: (large ? -28 : -22) * scale)
                .opacity(shine ? 1 : 0.35)
            Image(systemName: "sparkle")
                .font(.system(size: (large ? 13 : 11) * scale, weight: .bold))
                .foregroundColor(.white)
                .offset(x: (large ? 76 : 60) * scale, y: (large ? 30 : 24) * scale)
                .opacity(shine ? 0.4 : 1)
        }
        .allowsHitTesting(false)
    }

    private func word(_ text: String, colors: [Color], size: CGFloat) -> some View {
        Text(text)
            .font(GameFont.display(size))
            .foregroundStyle(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
            .shadow(color: Color.white.opacity(0.95), radius: 0, y: 1)
            .shadow(color: Color(hex: 0x7A2A10).opacity(0.42), radius: 0, y: 3)
    }
}

struct AnimatedSpeechBubble: View {
    var text: String
    var compact: Bool = false

    var body: some View {
        Text(text)
            .font(GameFont.headline(compact ? 17 : 23))
            .foregroundColor(GameTheme.navy)
            .multilineTextAlignment(.center)
            .padding(.horizontal, compact ? 16 : 22)
            .padding(.vertical, compact ? 11 : 16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, Color(hex: 0xEAF7FF), Color(hex: 0xFFF4D6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
            )
            .id(text)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.42, dampingFraction: 0.7), value: text)
            .accessibilityAddTraits(.isHeader)
    }
}
