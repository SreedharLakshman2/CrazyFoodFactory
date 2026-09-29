import SwiftUI
import UIKit

struct ResultView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var shareItem: ShareItem?

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground(celebrate: true)
                ConfettiView()
                VStack(spacing: short ? 14 : 20) {
                    RibbonTitle(text: store.currentResult?.title ?? "Yummy!")
                        .padding(.top, 16)

                    if let result = store.currentResult {
                        FoodIllustrationView(
                            food: result.food,
                            placed: result.placed,
                            size: short ? 200 : 228,
                            cuteFace: result.food == .burger
                        )
                        .bounceOn(true)

                        ResultCard(result: result)
                            .padding(.horizontal, 32)
                    }

                    Spacer(minLength: 8)

                    CrazyButton(title: "SHARE REWARD", icon: "square.and.arrow.up", kind: .play) {
                        shareReward()
                    }
                    .factoryButtonWidth()
                    .padding(.horizontal, 32)

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
        .onAppear {
            AudioManager.shared.celebrate()
            if ProcessInfo.processInfo.arguments.contains("-openshare") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    shareReward()
                }
            }
        }
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.image])
        }
    }

    private func shareReward() {
        let food = store.currentResult?.food ?? store.selectedFood
        let result = store.currentResult
        let reward = RewardCatalog.all.first(where: { $0.food == food })
            ?? Reward(
                id: "food-\(food.rawValue)",
                title: result?.title ?? "\(food.displayName) Star",
                subtitle: result?.message ?? "You cooked \(food.displayName)!",
                food: food,
                starsNeeded: 0
            )
        let image = RewardCardRenderer.image(for: reward)
        shareItem = ShareItem(image: image)
        AudioManager.shared.success()
        Haptics.success()
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
