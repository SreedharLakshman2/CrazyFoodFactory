import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground()

                VStack(spacing: metrics.compact ? 10 : 14) {
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
                    .padding(.horizontal, 8)

                    if metrics.pad { Spacer(minLength: 6) }

                    BrandWordmark(
                        large: !metrics.compact,
                        scale: metrics.compact ? 0.82 : (metrics.pad ? min(metrics.scale, 1.28) : 1)
                    )

                    Text(Brand.tagline)
                        .font(GameFont.caption(metrics.type(15, cap: 22)))
                        .foregroundColor(GameTheme.navy.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, metrics.pad ? 48 : 28)

                    chefStage(metrics: metrics)
                        .frame(minHeight: metrics.compact ? 168 : (metrics.pad ? 260 : 220))
                        .frame(maxHeight: metrics.pad ? min(geo.size.height * 0.38, 400) : .infinity)

                    LearnIngredientsIngress(compact: metrics.compact) {
                        router.go(.ingredientSchool)
                    }
                    .padding(.horizontal, metrics.pad ? 28 : 22)

                    CrazyButton(title: "PLAY", icon: "play.fill") {
                        router.go(.foodSelection)
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, metrics.pad ? 72 : 40)

                    if metrics.pad { Spacer(minLength: 6) }
                }
                .factoryLandingWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
                .padding(.horizontal, 8)
                .scaleEffect(appear ? 1 : 0.94)
                .opacity(appear ? 1 : 0)
            }
            .factoryMetrics(metrics)
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

    private func chefStage(metrics: FactoryMetrics) -> some View {
        ChefFoodStage(
            pose: .idle,
            foods: [.pizza, .iceCream, .dosa, .burrito],
            chefSize: metrics.compact ? 168 : metrics.art(210, cap: 300),
            foodSize: metrics.compact ? 62 : metrics.art(76, cap: 100)
        )
    }
}

private struct LearnIngredientsIngress: View {
    var compact: Bool = false
    var action: () -> Void
    @Environment(\.factoryMetrics) private var metrics

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
            VStack(alignment: .leading, spacing: compact ? 8 : 10) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: metrics.type(14, cap: 18), weight: .bold))
                        .foregroundColor(Color(hex: 0xFF7A28))
                    Text("INGREDIENT SCHOOL")
                        .font(GameFont.caption(metrics.type(13, cap: 18)))
                        .foregroundColor(Color(hex: 0xFF7A28))
                        .tracking(0.6)
                    Spacer(minLength: 6)
                    Text("\(IngredientID.schoolRoster.count) foods")
                        .font(GameFont.caption(metrics.type(13, cap: 18)))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color(hex: 0xFF7A28)))
                }

                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("What is \(id.displayName)?")
                            .font(GameFont.headline(metrics.type(18, cap: 28)))
                            .foregroundColor(GameTheme.navy)
                        Text(compact ? id.kidFactShort : id.kidFact)
                            .font(GameFont.body(metrics.type(15, cap: 22)))
                            .foregroundColor(GameTheme.navy.opacity(0.78))
                            .lineLimit(compact ? 2 : 3)
                            .fixedSize(horizontal: false, vertical: true)
                        if compact == false {
                            Text(id.cookingUse)
                                .font(GameFont.caption(metrics.type(14, cap: 20)))
                                .foregroundColor(Color(hex: 0xE85A12))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer(minLength: 4)
                    IngredientArt(id: id)
                        .frame(
                            width: compact ? 56 : metrics.art(72, cap: 96),
                            height: compact ? 56 : metrics.art(72, cap: 96)
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
                        ForEach(Array(thumbs.prefix(compact || metrics.size.width < 520 ? 3 : 5)), id: \.self) { thumb in
                            IngredientArt(id: thumb)
                                .frame(width: metrics.art(32, cap: 42), height: metrics.art(32, cap: 42))
                                .padding(3)
                                .background(Circle().fill(Color.white))
                                .overlay(Circle().stroke(Color.white.opacity(0.9), lineWidth: 1.5))
                        }
                    }
                    Spacer(minLength: 8)
                    HStack(spacing: 6) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: metrics.type(12, cap: 16), weight: .bold))
                        Text(compact || metrics.size.width < 520 ? "Hear it" : "Hear it • How chefs cook")
                            .font(GameFont.headline(metrics.type(14, cap: 18)))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Image(systemName: "chevron.right")
                            .font(.system(size: metrics.type(13, cap: 16), weight: .heavy))
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
