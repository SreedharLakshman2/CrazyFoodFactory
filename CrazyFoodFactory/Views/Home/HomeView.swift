import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            let pad = FactoryLayout.isRegular(geo.size)
            ZStack {
                FactoryBackground()
                FloatingFoods()

                VStack(spacing: short ? 10 : 16) {
                    HStack {
                        SettingsButton { router.showSettings = true }
                        Spacer()
                        CircleIconButton(
                            systemName: store.save.musicEnabled ? "music.note" : "speaker.slash.fill",
                            accessibility: store.save.musicEnabled ? "Turn music off" : "Turn music on",
                            dimmed: !store.save.musicEnabled
                        ) {
                            store.setMusic(!store.save.musicEnabled)
                        }
                    }
                    .padding(.horizontal, 18)

                    Spacer(minLength: 4)
                    titleBlock(scale: pad ? 1.18 : 1)
                    Text(Brand.tagline)
                        .font(GameFont.caption(short ? 13 : (pad ? 18 : 15)))
                        .foregroundColor(GameTheme.navy.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 4)
                        .zIndex(2)

                    chefStage(short: short, pad: pad)
                        .padding(.vertical, 4)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 36)
                    .padding(.bottom, 8)

                    HStack(spacing: 12) {
                        miniLink(title: "MAP", icon: "map.fill") { router.go(.levelMap) }
                        miniLink(title: "LEVEL \(store.save.currentLevel)", icon: "star.fill") {
                            store.startLevel(store.save.currentLevel)
                            router.go(.foodSelection)
                        }
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 8 : 16)
                }
                .factoryReadableWidth()
                .padding(.top, 8)
                .scaleEffect(appear ? 1 : 0.92)
                .opacity(appear ? 1 : 0)
            }
        }
        .statusBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.62, dampingFraction: 0.78)) {
                appear = true
            }
        }
    }

    private func titleBlock(scale: CGFloat) -> some View {
        ZStack {
            gear(size: 34 * scale).offset(x: -118 * scale, y: -36 * scale)
            gear(size: 26 * scale).offset(x: 112 * scale, y: -18 * scale)
            VStack(spacing: -6 * scale) {
                titleWord("Crazy", size: 46 * scale, colors: [Color(hex: 0xFFE14A), Color(hex: 0xFFB300)])
                titleWord("Food", size: 50 * scale, colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A1F)])
                titleWord("Factory", size: 46 * scale, colors: [Color(hex: 0xFF5A8A), Color(hex: 0xE53935)])
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Crazy Food Factory")
        .accessibilityAddTraits(.isHeader)
    }

    private func titleWord(_ text: String, size: CGFloat, colors: [Color]) -> some View {
        ZStack {
            Text(text)
                .font(GameFont.display(size))
                .foregroundColor(Color(hex: 0x8D4E12).opacity(0.35))
                .offset(y: 3)
            Text(text)
                .font(GameFont.display(size))
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                .shadow(color: .white.opacity(0.6), radius: 0, y: 1)
        }
    }

    private func gear(size: CGFloat) -> some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: size, weight: .bold))
            .foregroundColor(Color.white.opacity(0.55))
            .accessibilityHidden(true)
    }

    private func chefStage(short: Bool, pad: Bool) -> some View {
        let chef: CGFloat = pad ? 230 : (short ? 168 : 196)
        let snack: CGFloat = pad ? 92 : 72
        return ZStack {
            ChefCharacter(pose: .idle, size: chef, showsSpatula: true)
            FoodIllustrationView(food: .burger, placed: [.bun, .patty, .cheese, .lettuce, .topBun], size: snack)
                .offset(x: pad ? -130 : -108, y: pad ? 70 : 58)
            FoodIllustrationView(food: .pizza, placed: [.dough, .tomatoSauce, .cheese, .pepperoni], size: snack + 4)
                .offset(x: pad ? 130 : 108, y: pad ? 54 : 46)
        }
        .frame(height: pad ? 320 : (short ? 236 : 276))
        .padding(.top, 6)
    }

    private func miniLink(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            AudioManager.shared.tap()
            action()
        } label: {
            Label(title, systemImage: icon)
                .font(GameFont.body(14))
                .foregroundColor(GameTheme.navy)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.white.opacity(0.85)))
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(title)
    }
}

#Preview("iPhone") {
    HomeView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}

#Preview("iPad") {
    HomeView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
        .previewDevice("iPad Pro 13-inch (M4)")
}
