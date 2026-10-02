import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            let pad = FactoryLayout.isRegular(geo.size)
            let scale = FactoryLayout.scale(in: geo.size)
            let wordScale: CGFloat = short ? 0.86 : (pad ? min(scale, 1.38) : 1)
            ZStack {
                FactoryBackground()

                VStack(spacing: short ? 10 : 12 + 8 * (scale - 1)) {
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
                    .padding(.horizontal, pad ? 28 : 18)

                    if pad {
                        Color.clear.frame(height: 8)
                    } else {
                        Spacer(minLength: 4)
                    }

                    BrandWordmark(large: !short, scale: wordScale)

                    Text(Brand.tagline)
                        .font(GameFont.caption(short ? 13 : min(15 * scale, 20)))
                        .foregroundColor(GameTheme.navy.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, pad ? 48 : 28)

                    chefStage(short: short, scale: scale)
                        .frame(minHeight: short ? 168 : 220)
                        .frame(maxHeight: .infinity)

                    LearnIngredientsIngress(scale: scale, compact: short) {
                        router.go(.ingredientSchool)
                    }
                    .padding(.horizontal, pad ? 36 : 28)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, pad ? 80 : 40)
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 10 : 16)
                }
                .factoryLandingWidth()
                .padding(.top, pad ? 12 : 8)
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

    private func chefStage(short: Bool, scale: CGFloat) -> some View {
        GeometryReader { geo in
            let cap: CGFloat = short ? 200 : 400
            let chef = min(max(geo.size.height * 0.72, short ? 150 : 200 * scale * 0.92), cap)
            let food = min(chef * 0.32, 110)
            let spread = chef / 200
            ZStack {
                ChefCharacter(pose: .idle, size: chef, showsSpatula: true)
                FoodIllustrationView(food: .pizza, size: food)
                    .offset(x: -112 * spread, y: 44 * spread)
                FoodIllustrationView(food: .dosa, size: food * 0.92)
                    .offset(x: -110 * spread, y: 112 * spread)
                FoodIllustrationView(food: .iceCream, size: food * 0.95)
                    .offset(x: 114 * spread, y: 4 * spread)
                FoodIllustrationView(food: .burrito, size: food * 0.88)
                    .offset(x: 116 * spread, y: 108 * spread)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

private struct LearnIngredientsIngress: View {
    var scale: CGFloat
    var compact: Bool = false
    var action: () -> Void

    private let teasers: [IngredientID] = [.tomato, .mango, .paneer, .chickpeas, .avocado, .rice]
    private let thumbs: [IngredientID] = [.tomato, .mango, .paneer, .chickpeas, .avocado]

    var body: some View {
        TimelineView(.periodic(from: .now, by: 3.4)) { timeline in
            let index = Int(timeline.date.timeIntervalSinceReferenceDate / 3.4) % teasers.count
            let id = teasers[index]
            button(for: id)
                .animation(.easeInOut(duration: 0.35), value: id)
        }
    }

    private func button(for id: IngredientID) -> some View {
        Button {
            AudioManager.shared.tap()
            action()
        } label: {
            VStack(alignment: .leading, spacing: compact ? 8 : 10 * max(scale, 1)) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 14 * scale, weight: .bold))
                        .foregroundColor(Color(hex: 0xFF7A28))
                    Text("INGREDIENT SCHOOL")
                        .font(GameFont.caption(min(12 * scale, 15)))
                        .foregroundColor(Color(hex: 0xFF7A28))
                        .tracking(0.6)
                    Spacer(minLength: 6)
                    Text("\(IngredientID.schoolRoster.count) foods")
                        .font(GameFont.caption(min(12 * scale, 15)))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color(hex: 0xFF7A28)))
                }

                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("What is \(id.displayName)?")
                            .font(GameFont.headline(min(18 * scale, 24)))
                            .foregroundColor(GameTheme.navy)
                        Text(compact ? id.kidFactShort : id.kidFact)
                            .font(GameFont.body(min(14 * scale, 18)))
                            .foregroundColor(GameTheme.navy.opacity(0.78))
                            .lineLimit(compact ? 2 : 3)
                            .fixedSize(horizontal: false, vertical: true)
                        if compact == false {
                            Text(id.cookingUse)
                                .font(GameFont.caption(min(13 * scale, 16)))
                                .foregroundColor(Color(hex: 0xE85A12))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer(minLength: 4)
                    IngredientArt(id: id)
                        .frame(
                            width: compact ? 56 : min(72 * scale, 96),
                            height: compact ? 56 : min(72 * scale, 96)
                        )
                        .padding(compact ? 6 : 10)
                        .background(
                            Circle().fill(
                                LinearGradient(
                                    colors: [Color.white, id.trayColor.opacity(0.45)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        )
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                }

                HStack(spacing: 8) {
                    HStack(spacing: -10) {
                        ForEach(Array(thumbs.prefix(compact || scale < 1.25 ? 3 : 5)), id: \.self) { thumb in
                            IngredientArt(id: thumb)
                                .frame(width: min(32 * scale, 42), height: min(32 * scale, 42))
                                .padding(3)
                                .background(Circle().fill(Color.white))
                                .overlay(Circle().stroke(Color.white.opacity(0.9), lineWidth: 1.5))
                        }
                    }
                    Spacer(minLength: 8)
                    HStack(spacing: 6) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 12 * scale, weight: .bold))
                        Text(compact || scale < 1.25 ? "Hear it" : "Hear it • How chefs cook")
                            .font(GameFont.headline(min(13 * scale, 16)))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13 * scale, weight: .heavy))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color(hex: 0xFF7A28)))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, compact ? 12 : 14)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color(hex: 0xE8F8FF),
                                Color(hex: 0xFFF4D6),
                                Color(hex: 0xFFE7F2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white, Color(hex: 0xFFE56A), Color(hex: 0xFFB6E8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(color: Color(hex: 0x4EC3FF).opacity(0.22), radius: 12, y: 6)
        }
        .buttonStyle(PressScaleStyle(pressedScale: 0.98))
        .accessibilityLabel(
            "Ingredient School. \(IngredientID.schoolRoster.count) foods. What is \(id.displayName)? \(id.kidFact) \(id.cookingUse). Hear it and how chefs cook."
        )
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
}
