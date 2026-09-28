import SwiftUI
import UIKit

struct RewardsView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @State private var shareItem: ShareItem?

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            FactoryBackground(compact: true)
            VStack(spacing: 12) {
                HStack {
                    BackCircleButton { router.go(.home) }
                    Spacer()
                    Text("Rewards")
                        .font(GameFont.title(28))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Spacer()
                    Color.clear.frame(width: 52, height: 52)
                }
                .padding(.horizontal, 16)

                Text("Cook dishes and collect stars to unlock shareable chef cards.")
                    .font(GameFont.caption(14))
                    .foregroundColor(GameTheme.navy.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(RewardCatalog.all) { reward in
                            rewardTile(reward)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 28)
                }
            }
            .factoryReadableWidth()
            .padding(.top, 8)
        }
        .statusBarHidden(true)
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.image])
        }
    }

    private func rewardTile(_ reward: Reward) -> some View {
        let unlocked = store.save.unlockedRewardIDs.contains(reward.id)
        return Button {
            guard unlocked else { return }
            share(reward)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    RewardBadge(reward: reward, unlocked: unlocked)
                        .frame(height: 92)
                    if !unlocked {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(GameTheme.navy.opacity(0.55))
                    }
                }
                Text(reward.title)
                    .font(GameFont.headline(15))
                    .foregroundColor(GameTheme.navy)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(unlocked ? "Tap to share" : lockHint(reward))
                    .font(GameFont.caption(12))
                    .foregroundColor(GameTheme.navy.opacity(0.55))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(unlocked ? GameTheme.primaryYellow : Color.white, lineWidth: 3)
            )
        }
        .buttonStyle(PressScaleStyle())
        .disabled(!unlocked)
        .accessibilityLabel(unlocked ? "\(reward.title). Share" : "\(reward.title). Locked")
    }

    private func lockHint(_ reward: Reward) -> String {
        if let food = reward.food {
            return "Cook \(food.displayName)"
        }
        return "Need \(reward.starsNeeded) stars"
    }

    private func share(_ reward: Reward) {
        let image = RewardCardRenderer.image(for: reward)
        shareItem = ShareItem(image: image)
        AudioManager.shared.success()
    }
}

struct RewardBadge: View {
    let reward: Reward
    var unlocked: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(unlocked ? Color(hex: 0xFFE56A) : Color(hex: 0xD7E6F2))
            if let food = reward.food {
                FoodIllustrationView(food: food, size: 72)
                    .opacity(unlocked ? 1 : 0.28)
            } else {
                Image(systemName: "star.fill")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(unlocked ? GameTheme.orange : Color.white.opacity(0.8))
            }
        }
        .frame(width: 86, height: 86)
    }
}

struct RewardShareCard: View {
    let reward: Reward

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x5CC8FF), Color(hex: 0xFFE56A), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(spacing: 28) {
                Text(Brand.name)
                    .font(GameFont.display(54))
                    .foregroundColor(GameTheme.navy)
                Text("Reward Unlocked!")
                    .font(GameFont.headline(28))
                    .foregroundColor(GameTheme.navy.opacity(0.7))
                RewardBadge(reward: reward, unlocked: true)
                    .scaleEffect(2.1)
                    .frame(height: 200)
                Text(reward.title)
                    .font(GameFont.display(64))
                    .foregroundColor(GameTheme.navy)
                Text(reward.subtitle)
                    .font(GameFont.headline(30))
                    .foregroundColor(GameTheme.navy.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
                Text(Brand.copyright)
                    .font(GameFont.caption(18))
                    .foregroundColor(GameTheme.navy.opacity(0.5))
                    .padding(.top, 20)
            }
            .padding(50)
        }
    }
}

#Preview {
    RewardsView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
