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

                    title
                        .scaleEffect(pad ? 1.12 : (short ? 0.88 : 1))

                    Text(Brand.tagline)
                        .font(GameFont.caption(short ? 13 : 15))
                        .foregroundColor(GameTheme.navy.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    chefStage(short: short, pad: pad)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 40)
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 14 : 22)
                }
                .factoryReadableWidth()
                .padding(.top, 8)
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

    private var title: some View {
        Group {
            if GameArt.exists("ArtTitleLogo") {
                Image("ArtTitleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 168)
            } else {
                VStack(spacing: -4) {
                    Text("Crazy").font(GameFont.display(48)).foregroundColor(Color(hex: 0xFFE14A))
                    Text("Food").font(GameFont.display(52)).foregroundColor(Color(hex: 0xFF8A3D))
                    Text("Factory").font(GameFont.display(48)).foregroundColor(Color(hex: 0xFF5A8A))
                }
            }
        }
        .accessibilityLabel("Crazy Food Factory")
        .accessibilityAddTraits(.isHeader)
    }

    private func chefStage(short: Bool, pad: Bool) -> some View {
        let chef: CGFloat = pad ? 270 : (short ? 200 : 236)
        return ZStack {
            ChefCharacter(pose: .idle, size: chef, showsSpatula: true)
            FoodIllustrationView(food: .pizza, size: pad ? 92 : 78)
                .offset(x: pad ? -148 : -120, y: pad ? 72 : 58)
            FoodIllustrationView(food: .burger, size: pad ? 84 : 70)
                .offset(x: pad ? -146 : -118, y: pad ? 158 : 132)
            FoodIllustrationView(food: .iceCream, size: pad ? 88 : 74)
                .offset(x: pad ? 148 : 122, y: pad ? 18 : 10)
            FoodIllustrationView(food: .donut, size: pad ? 82 : 68)
                .offset(x: pad ? 148 : 124, y: pad ? 150 : 126)
        }
        .frame(height: pad ? 330 : (short ? 240 : 290))
    }
}

#Preview("iPhone") {
    HomeView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
