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

                VStack(spacing: short ? 8 : 12) {
                    topBar
                    IngredientTray(
                        ingredients: game.definition.ingredients,
                        placed: game.placed,
                        onTap: game.tapIngredient
                    )
                    workstation(short: short, width: geo.size.width)
                    if game.definition.showsOven {
                        ovenRow
                    }
                    Spacer(minLength: 4)
                }
                .padding(.top, 6)
                .modifier(ShakeEffect(animatableData: game.shake))

                if let flying = game.flying {
                    IngredientArt(id: flying)
                        .frame(width: 48, height: 48)
                        .offset(y: short ? 40 : 20)
                        .transition(.scale)
                }

                if let oops = game.oopsText, game.activeChaos == nil {
                    Text(oops)
                        .font(GameFont.title(28))
                        .foregroundColor(GameTheme.comicRed)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.white))
                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                        .transition(.scale)
                }

                if game.phase == .complete {
                    completeOverlay
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
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
        ZStack {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .frame(height: short ? 300 : 340)
                .padding(.horizontal, 16)
                .softCardShadow(0.1)

            if let speech = game.speech {
                SpeechBubble(text: speech, compact: true)
                    .offset(y: short ? -118 : -132)
            }

            HStack(alignment: .bottom, spacing: 0) {
                ChefCharacter(pose: game.chefPose, size: short ? 118 : 136, showsSpatula: true)
                    .padding(.leading, 8)
                Spacer(minLength: 0)
                ZStack {
                    FoodIllustrationView(
                        food: game.definition.type,
                        placed: game.placed,
                        melted: game.melted,
                        size: short ? 150 : 176
                    )
                    .scaleEffect(game.foodBounce ? 1.1 : game.overlayScale)
                    .rotationEffect(.degrees(game.foodSpin ? 360 : 0))
                    .animation(GameAnimations.bounce, value: game.foodBounce)
                    .modifier(ShakeEffect(amount: 6, shakes: 2, animatableData: game.sandwichShake ? 1 : 0))
                    SparkleEffect(tick: game.sparkleTick)
                }
                .frame(width: width * 0.48)
                .padding(.trailing, 18)
            }
            .padding(.top, 28)
        }
    }

    private var ovenRow: some View {
        Button {
            game.tapOven()
        } label: {
            HStack(spacing: 12) {
                OvenArt(glowing: game.ovenGlow, meltedInside: game.melted)
                    .frame(width: 74, height: 64)
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.definition.ovenIsTrap ? "Oven" : "Bake it!")
                        .font(GameFont.headline(18))
                        .foregroundColor(GameTheme.navy)
                    if game.phase == .cooking {
                        ProgressView(value: game.cookProgress)
                            .tint(GameTheme.orange)
                    } else {
                        Text(game.definition.ovenIsTrap ? "Don't melt it!" : "Tap when ready")
                            .font(GameFont.caption(13))
                            .foregroundColor(GameTheme.navy.opacity(0.7))
                    }
                }
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.white))
            .padding(.horizontal, 18)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(game.definition.ovenIsTrap ? "Oven trap" : "Put food in oven")
    }

    private var completeOverlay: some View {
        VStack {
            Spacer()
            Text(game.speech ?? "YUMMY!")
                .font(GameFont.title(30))
                .foregroundColor(GameTheme.navy)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.white))
                .padding(.bottom, 24)
        }
        .transition(.scale)
    }

    private func finishSuccess() {
        let result = game.makeResult()
        store.applyResult(result)
        router.go(.result)
    }
}

#Preview {
    GameplayView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
