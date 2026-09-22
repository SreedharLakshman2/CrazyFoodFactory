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
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground(compact: true)

                VStack(spacing: short ? 10 : 14) {
                    topBar
                    IngredientTray(
                        ingredients: game.definition.ingredients,
                        placed: game.placed,
                        onTap: game.tapIngredient
                    )
                    if let speech = game.speech {
                        SpeechBubble(text: speech, compact: true)
                    }
                    Spacer(minLength: 8)
                    workstation(short: short, width: geo.size.width)
                    Spacer(minLength: 12)
                }
                .factoryReadableWidth()
                .padding(.top, 8)
                .modifier(ShakeEffect(animatableData: game.shake))

                if let flying = game.flying {
                    IngredientArt(id: flying)
                        .frame(width: 52, height: 52)
                        .transition(.scale)
                }

                if let oops = game.oopsText, game.activeChaos == nil {
                    Text(oops)
                        .font(GameFont.title(30))
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
        .padding(.horizontal, 14)
    }

    private func workstation(short: Bool, width: CGFloat) -> some View {
        let foodSize: CGFloat = short ? 188 : 216
        let chefSize: CGFloat = short ? 200 : 236
        return ZStack(alignment: .bottom) {
            FactoryTable()
                .frame(width: short ? 220 : 248, height: short ? 74 : 84)
                .offset(x: 28, y: -6)

            HStack(alignment: .bottom, spacing: 0) {
                ChefCharacter(pose: game.chefPose, size: chefSize)
                    .offset(x: -4, y: 10)

                Spacer(minLength: 0)

                ZStack {
                    if game.definition.type == .donut {
                        FrostingPipe()
                            .offset(y: -foodSize * 0.52)
                    }
                    FoodIllustrationView(
                        food: game.definition.type,
                        placed: game.placed,
                        melted: game.melted,
                        size: foodSize
                    )
                    .scaleEffect(game.foodBounce ? 1.08 : game.overlayScale)
                    .rotationEffect(.degrees(game.foodSpin ? 360 : 0))
                    .animation(GameAnimations.bounce, value: game.foodBounce)
                    SparkleEffect(tick: game.sparkleTick)
                }
                .padding(.bottom, 30)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 2)

            if game.definition.ovenIsTrap {
                Button {
                    game.tapOven()
                } label: {
                    OvenArt(glowing: game.ovenGlow, meltedInside: game.melted)
                        .frame(width: short ? 112 : 128, height: short ? 112 : 128)
                }
                .buttonStyle(PressScaleStyle())
                .accessibilityLabel("Oven")
                .offset(x: short ? 138 : 154, y: -18)
            }
        }
        .frame(height: short ? 290 : 340)
        .padding(.horizontal, 4)
        .frame(maxWidth: min(width, 540))
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
