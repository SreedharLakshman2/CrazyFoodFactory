import SwiftUI

struct GameplayView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @StateObject private var game: GameplayViewModel

    init(definition: FoodGameDefinition? = nil, level: LevelDefinition? = nil) {
        let lvl = level ?? LevelCatalog.level(1)
        let def = definition ?? FoodCatalog.definition(for: .pizza, level: lvl)
        _game = StateObject(wrappedValue: GameplayViewModel(definition: def, level: lvl))
    }

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground(compact: true)

                VStack(spacing: metrics.compact ? 10 : 14) {
                    topBar
                    IngredientTray(
                        ingredients: game.definition.ingredients,
                        placed: game.placed,
                        focused: game.trayFocus,
                        compact: metrics.compact,
                        onTap: game.tapIngredient
                    )
                    if let text = game.lastLesson ?? game.speech, !text.isEmpty {
                        SpeechBubble(text: text, compact: true)
                            .padding(.horizontal, metrics.pad ? 48 : 36)
                            .animation(.spring(response: 0.42, dampingFraction: 0.7), value: text)
                    }
                    workstation(metrics: metrics)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .factoryReadableWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
                .padding(.horizontal, 8)
                .modifier(ShakeEffect(animatableData: game.shake))

                if let flying = game.flying {
                    IngredientArt(id: flying)
                        .frame(width: metrics.art(56, cap: 72), height: metrics.art(56, cap: 72))
                        .transition(.scale)
                }

                if let oops = game.oopsText, game.activeChaos == nil {
                    Text(oops)
                        .font(GameFont.title(metrics.type(30, cap: 42)))
                        .foregroundColor(GameTheme.comicRed)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.white))
                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                }

                if router.showPause {
                    PauseOverlay(
                        onResume: { router.showPause = false },
                        onHome: {
                            router.showPause = false
                            router.go(.home)
                        },
                        onSettings: { router.showSettings = true }
                    )
                }

                if let chaos = game.activeChaos, chaos.retry != .continuePlay {
                    ChaosEventView(event: chaos, food: game.definition.type, melted: game.melted) {
                        game.keepCrazy()
                    } retry: {
                        game.retry()
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .factoryMetrics(metrics)
        }
        .statusBarHidden(true)
        .onChange(of: game.phase) { _, phase in
            if phase == .complete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    finishSuccess()
                }
            }
        }
    }

    private var topBar: some View {
        HStack {
            PauseButton { router.showPause = true }
            Spacer()
            TitleChip(food: game.definition.type, title: game.definition.title)
            Spacer()
            ProgressStars(filled: game.starPreview)
        }
        .padding(.horizontal, 10)
    }

    private func workstation(metrics: FactoryMetrics) -> some View {
        GeometryReader { geo in
            let foodSize = min(geo.size.height * 0.62, metrics.art(250, cap: metrics.compact ? 260 : 380))
            let chefSize = min(geo.size.height * 0.56, metrics.art(210, cap: metrics.compact ? 220 : 320))
            ZStack {
                FactoryTable()
                    .frame(width: min(geo.size.width * 0.62, metrics.pad ? 420 : 320), height: metrics.compact ? 78 : 96)
                    .offset(y: -4)

                FoodIllustrationView(
                    food: game.definition.type,
                    placed: game.placed,
                    melted: game.melted,
                    size: foodSize
                )
                .scaleEffect(game.foodBounce ? 1.08 : game.overlayScale)
                .rotationEffect(.degrees(game.foodSpin ? 360 : 0))
                .animation(GameAnimations.bounce, value: game.foodBounce)
                .padding(.bottom, 36)
                .overlay { SparkleEffect(tick: game.sparkleTick) }

                ChefCharacter(pose: game.chefPose, size: chefSize)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                    .offset(y: 8)

                if game.definition.ovenIsTrap {
                    Button {
                        game.tapOven()
                    } label: {
                        OvenArt(glowing: game.ovenGlow, meltedInside: game.melted)
                            .frame(width: metrics.art(108, cap: 140), height: metrics.art(108, cap: 140))
                    }
                    .buttonStyle(PressScaleStyle())
                    .accessibilityLabel("Oven")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 8)
                    .offset(y: 6)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private func finishSuccess() {
        store.applyResult(game.makeResult())
        router.go(.result)
    }
}

#Preview {
    GameplayView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
