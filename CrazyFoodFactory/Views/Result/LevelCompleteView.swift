import SwiftUI

struct LevelCompleteView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                LinearGradient(
                    colors: [Color(hex: 0x7AD4FF), Color(hex: 0xFFE56A).opacity(0.55), Color(hex: 0xFFF4EC)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: short ? 14 : 20) {
                    Text("LEVEL\nCOMPLETE!")
                        .font(GameFont.display(short ? 38 : 44))
                        .foregroundColor(GameTheme.navy)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    StarRating(filled: max(store.save.stars(for: max(1, store.save.currentLevel - 1)), store.currentResult?.stars ?? 0), size: 42)

                    Text("You made:")
                        .font(GameFont.headline(18))
                        .foregroundColor(GameTheme.navy.opacity(0.75))

                    foodRow
                        .padding(.horizontal, 28)

                    Spacer(minLength: 8)

                    CrazyButton(title: "NEXT LEVEL", icon: "arrow.right", kind: .next) {
                        store.startLevel(store.save.currentLevel)
                        router.go(.levelMap)
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
        .onAppear { AudioManager.shared.levelComplete() }
    }

    private var foodRow: some View {
        let foods = store.sessionCompleted.isEmpty ? store.currentLevel.requiredFoods : store.sessionCompleted
        return HStack(spacing: 16) {
            ForEach(foods, id: \.self) { food in
                VStack(spacing: 6) {
                    FoodIllustrationView(food: food, size: 72)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(GameTheme.successGreen)
                        .font(.system(size: 18, weight: .bold))
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
        .softCardShadow(0.08)
    }
}

#Preview {
    LevelCompleteView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
