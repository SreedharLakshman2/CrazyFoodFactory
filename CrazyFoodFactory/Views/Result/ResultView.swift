import SwiftUI
import UIKit

struct ResultView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var shareItem: ShareItem?

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground(celebrate: true)
                ConfettiView()
                VStack(spacing: metrics.compact ? 12 : 18) {
                    RibbonTitle(text: store.currentResult?.title ?? "Yummy!")

                    if let result = store.currentResult {
                        ViewThatFits(in: .vertical) {
                            dish(result, art: metrics.art(metrics.compact ? 200 : 228, cap: 300), compact: false)
                            dish(result, art: metrics.art(160, cap: 240), compact: false)
                            dish(result, art: metrics.art(130, cap: 200), compact: true)
                            dish(result, art: 96, compact: true)
                            ResultCard(result: result, compact: true)
                                .padding(.horizontal, 32)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        Spacer(minLength: 8)
                    }

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
                }
                .factoryReadableWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
            }
            .factoryMetrics(metrics)
        }
        .statusBarHidden(true)
        .askForReviewIfReady(store)
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

    private func dish(_ result: FoodResult, art: CGFloat, compact: Bool) -> some View {
        VStack(spacing: compact ? 8 : 14) {
            FoodIllustrationView(
                food: result.food,
                placed: result.placed,
                size: art,
                cuteFace: result.food == .burger
            )
            .bounceOn(true)

            ResultCard(result: result, compact: compact)
                .padding(.horizontal, 32)
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
        switch store.advanceAfterDish() {
        case .play:
            router.go(.gameplay)
        case .pickFood:
            router.go(.foodSelection)
        case .worldDone:
            AudioManager.shared.levelComplete()
            router.go(.levelComplete)
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
