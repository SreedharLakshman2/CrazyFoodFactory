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

                VStack(spacing: short ? 12 : 18) {
                    Text(store.currentResult?.title ?? "Yummy!")
                        .font(GameFont.display(short ? 34 : 40))
                        .foregroundColor(GameTheme.navy)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .padding(.top, 12)

                    StarRating(filled: store.currentResult?.stars ?? 3, size: 34)

                    if let result = store.currentResult {
                        FoodIllustrationView(food: result.food, placed: result.placed, size: short ? 170 : 200, cuteFace: result.food == .burger)
                            .bounceOn(true)
                        Text(result.message)
                            .font(GameFont.headline(18))
                            .foregroundColor(GameTheme.navy.opacity(0.8))
                        ResultCard(result: result)
                            .padding(.horizontal, 28)
                    }

                    Spacer(minLength: 8)

                    CrazyButton(title: "NEXT ORDER", icon: "arrow.right", kind: .next) {
                        advance()
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 28)

                    Button {
                        AudioManager.shared.tap()
                        router.go(.home)
                    } label: {
                        Label("HOME", systemImage: "house.fill")
                            .font(GameFont.headline(16))
                            .foregroundColor(GameTheme.navy)
                    }
                    .padding(.bottom, 10)
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
