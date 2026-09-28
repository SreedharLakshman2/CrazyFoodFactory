import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void
    @State private var burst = false
    @State private var showChef = false

    var body: some View {
        ZStack {
            FactoryBackground()
            if burst {
                ConfettiView(active: true)
            }
            VStack(spacing: 18) {
                Spacer()
                BrandWordmark(large: false)
                    .scaleEffect(burst ? 1 : 0.86)
                if showChef {
                    ChefCharacter(pose: .celebrating, size: 150, showsSpatula: true)
                        .transition(.opacity.combined(with: .offset(y: 16)))
                }
                Text(Brand.tagline)
                    .font(GameFont.caption(15))
                    .foregroundColor(GameTheme.navy)
                    .opacity(burst ? 1 : 0)
                Spacer()
            }
            .factoryReadableWidth()
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                burst = true
            }
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.35)) {
                    showChef = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                AudioManager.shared.success()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.15, execute: onFinished)
        }
        .accessibilityLabel(Brand.name)
    }
}

#Preview {
    SplashView(onFinished: {})
}
