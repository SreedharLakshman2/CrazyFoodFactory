import SwiftUI

struct ResultView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                GameTheme.resultGradient.ignoresSafeArea()
                ConfettiView()
                FactoryLottie(name: .yumHearts)
                    .frame(height: 180)
                    .offset(y: -40)
                    .allowsHitTesting(false)
                FactoryLottie(name: .yumBurst)
                    .frame(height: 120)
                    .offset(y: -210)
                    .allowsHitTesting(false)

                VStack(spacing: short ? 14 : 20) {
                    RibbonTitle(text: store.currentResult?.title ?? "Yummy!")
                        .padding(.top, 16)

                    if let result = store.currentResult {
                        FoodIllustrationView(
                            food: result.food,
                            placed: result.placed,
                            size: short ? 220 : 250,
                            cuteFace: result.food == .burger
                        )
                        .bounceOn(true)

                        ResultCard(result: result)
                            .padding(.horizontal, 32)
                    }

                    Spacer(minLength: 8)

                    CrazyButton(title: "NEXT ORDER", icon: "arrow.right", kind: .next) {
                        advance()
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 32)

                    HomeCircleButton {
                        router.go(.home)
                    }
                    .padding(.bottom, 12)
                }
                .factoryReadableWidth()
            }
        }
        .statusBarHidden(true)
    }

    private func advance() {
        if store.completeLevelIfNeeded() {
            AudioManager.shared.levelComplete()
            router.go(.levelComplete)
        } else if let next = store.nextFood() {
            store.select(next)
            router.go(.gameplay)
        } else {
            router.go(.foodSelection)
        }
    }
}

#Preview {
    let store = GameStateStore.preview
    store.currentResult = FoodResult(
        food: .burger,
        stars: 3,
        placed: [.bun, .patty, .cheese, .lettuce],
        keptCrazy: false,
        title: "Burger Done!",
        message: "Yummy!"
    )
    return ResultView()
        .environmentObject(AppRouter())
        .environmentObject(store)
}
