import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void
    @State private var burst = false

    var body: some View {
        ZStack {
            FactoryBackground()
            ConfettiView(active: burst)
            VStack(spacing: 18) {
                Spacer()
                ZStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .offset(x: -120, y: -30)
                        .rotationEffect(.degrees(burst ? 50 : 0))
                    VStack(spacing: -6) {
                        splashWord("Crazy", Color(hex: 0xFFE14A))
                        splashWord("Food", Color(hex: 0xFF8A3D))
                        splashWord("Factory", Color(hex: 0xFF5A8A))
                    }
                    .scaleEffect(burst ? 1 : 0.72)
                }
                ChefCharacter(pose: .celebrating, size: 150, showsSpatula: true)
                    .opacity(burst ? 1 : 0)
                    .offset(y: burst ? 0 : 24)
                Text(Brand.tagline)
                    .font(GameFont.caption(15))
                    .foregroundColor(GameTheme.navy)
                    .opacity(burst ? 1 : 0)
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                burst = true
            }
            AudioManager.shared.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onFinished)
        }
        .accessibilityLabel("Crazy Food Factory")
    }

    private func splashWord(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(GameFont.display(46))
            .foregroundColor(color)
            .shadow(color: Color(hex: 0x8D4E12).opacity(0.25), radius: 0, y: 3)
    }
}

#Preview {
    SplashView(onFinished: {})
}
