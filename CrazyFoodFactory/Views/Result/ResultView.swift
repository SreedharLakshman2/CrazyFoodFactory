import SwiftUI
import UIKit

struct ResultView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var shareImage: UIImage?
    @State private var showShare = false

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground()
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
        }
        .sheet(isPresented: $showShare) {
            if let shareImage {
                ShareSheet(items: [shareImage])
            }
        }
    }

    private func shareReward() {
        guard let result = store.currentResult else { return }
        let reward = RewardCatalog.all.first(where: { $0.food == result.food })
            ?? Reward(id: "food-\(result.food.rawValue)", title: result.title, subtitle: result.message, food: result.food, starsNeeded: 0)
        let renderer = ImageRenderer(content: RewardShareCard(reward: reward).frame(width: 1080, height: 1350))
        renderer.scale = 1
        if let image = renderer.uiImage {
            shareImage = image
            showShare = true
        }
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
