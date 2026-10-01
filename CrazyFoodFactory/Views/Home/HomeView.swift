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
                            systemName: "gift.fill",
                            accessibility: "Rewards"
                        ) {
                            router.go(.rewards)
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

                    Spacer(minLength: 4)

                    BrandWordmark(large: !short)
                        .scaleEffect(pad ? 1.08 : (short ? 0.86 : 1))

                    Text(Brand.tagline)
                        .font(GameFont.caption(short ? 13 : 15))
                        .foregroundColor(GameTheme.navy.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    chefStage(short: short, pad: pad)

                    learnCard
                        .padding(.horizontal, 28)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 40)
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 10 : 16)
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
            AudioManager.shared.applySettings(
                music: store.save.musicEnabled,
                sound: store.save.soundEnabled,
                speech: store.save.speechEnabled
            )
        }
    }

    private func chefStage(short: Bool, pad: Bool) -> some View {
        let chef: CGFloat = pad ? 250 : (short ? 160 : 200)
        return ZStack {
            ChefCharacter(pose: .idle, size: chef, showsSpatula: true)
            FoodIllustrationView(food: .pizza, size: pad ? 84 : 64)
                .offset(x: pad ? -148 : -112, y: pad ? 64 : 44)
            FoodIllustrationView(food: .dosa, size: pad ? 78 : 58)
                .offset(x: pad ? -146 : -110, y: pad ? 142 : 112)
            FoodIllustrationView(food: .iceCream, size: pad ? 80 : 60)
                .offset(x: pad ? 148 : 114, y: pad ? 12 : 4)
            FoodIllustrationView(food: .burrito, size: pad ? 76 : 56)
                .offset(x: pad ? 148 : 116, y: pad ? 136 : 108)
        }
        .frame(height: pad ? 300 : (short ? 188 : 236))
    }

    private var learnCard: some View {
        Button {
            AudioManager.shared.tap()
            router.go(.ingredientSchool)
        } label: {
            HStack(spacing: 10) {
                HStack(spacing: -10) {
                    IngredientArt(id: .tomato)
                        .frame(width: 36, height: 36)
                    IngredientArt(id: .mango)
                        .frame(width: 36, height: 36)
                    IngredientArt(id: .paneer)
                        .frame(width: 36, height: 36)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Learn Ingredients")
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                    Text("What they are • How we cook")
                        .font(GameFont.caption(12))
                        .foregroundColor(GameTheme.navy.opacity(0.62))
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(GameTheme.navy.opacity(0.35))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(color: Color(hex: 0x4EC3FF).opacity(0.18), radius: 8, y: 4)
        }
        .buttonStyle(PressScaleStyle(pressedScale: 0.98))
        .accessibilityLabel("Learn Ingredients")
    }
}

#Preview("iPhone") {
    HomeView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
