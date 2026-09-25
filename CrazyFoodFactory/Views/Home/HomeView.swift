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
                FactoryLottie(name: .yumStars)
                    .frame(height: 140)
                    .offset(y: -250)
                    .allowsHitTesting(false)

                VStack(spacing: short ? 8 : 14) {
                    HStack {
                        SettingsButton { router.showSettings = true }
                        CircleIconButton(
                            systemName: "book.fill",
                            accessibility: "How kids learn"
                        ) {
                            router.go(.howTo)
                        }
                        Spacer()
                        CircleIconButton(
                            systemName: "map.fill",
                            accessibility: "Level map"
                        ) {
                            router.go(.levelMap)
                        }
                        CircleIconButton(
                            systemName: store.save.musicEnabled ? "music.note" : "speaker.slash.fill",
                            accessibility: store.save.musicEnabled ? "Turn music off" : "Turn music on",
                            dimmed: !store.save.musicEnabled
                        ) {
                            store.setMusic(!store.save.musicEnabled)
                        }
                    }
                    .padding(.horizontal, 18)

                    Spacer(minLength: 2)

                    titleBlock(scale: pad ? 1.2 : (short ? 0.92 : 1))

                    Text(Brand.tagline)
                        .font(GameFont.caption(short ? 13 : 15))
                        .foregroundColor(GameTheme.navy.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    chefStage(short: short, pad: pad)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 40)
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 12 : 20)
                }
                .factoryReadableWidth()
                .padding(.top, 6)
                .scaleEffect(appear ? 1 : 0.94)
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
            Image(systemName: "gearshape.fill")
                .font(.system(size: 30 * scale, weight: .bold))
                .foregroundColor(Color.white.opacity(0.55))
                .offset(x: -120 * scale, y: -28 * scale)
            Image(systemName: "gearshape.fill")
                .font(.system(size: 22 * scale, weight: .bold))
                .foregroundColor(Color.white.opacity(0.45))
                .offset(x: 118 * scale, y: -8 * scale)
            VStack(spacing: -4 * scale) {
                titleWord("Crazy", size: 48 * scale, colors: [Color(hex: 0xFFE14A), Color(hex: 0xFFB300)])
                titleWord("Food", size: 52 * scale, colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A1F)])
                titleWord("Factory", size: 48 * scale, colors: [Color(hex: 0xFF5A8A), Color(hex: 0xE53935)])
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
                .foregroundColor(Color(hex: 0x8D4E12).opacity(0.28))
                .offset(y: 3)
            Text(text)
                .font(GameFont.display(size))
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
        }
    }

    private func chefStage(short: Bool, pad: Bool) -> some View {
        let chef: CGFloat = pad ? 280 : (short ? 210 : 250)
        return ZStack {
            ChefCharacter(pose: .idle, size: chef, showsSpatula: true)
            FoodIllustrationView(food: .pizza, size: pad ? 96 : 82)
                .offset(x: pad ? -150 : -124, y: pad ? 70 : 56)
            FoodIllustrationView(food: .burger, size: pad ? 88 : 74)
                .offset(x: pad ? -148 : -122, y: pad ? 156 : 130)
            FoodIllustrationView(food: .iceCream, size: pad ? 92 : 78)
                .offset(x: pad ? 150 : 126, y: pad ? 16 : 8)
            FoodIllustrationView(food: .donut, size: pad ? 86 : 72)
                .offset(x: pad ? 150 : 128, y: pad ? 148 : 122)
        }
        .frame(height: pad ? 340 : (short ? 250 : 300))
    }
}

#Preview("iPhone") {
    HomeView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
