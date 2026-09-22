import SwiftUI

struct LevelCompleteView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                GameTheme.celebrateGradient.ignoresSafeArea()
                ConfettiView()

                VStack(spacing: short ? 12 : 18) {
                    Text("LEVEL\nCOMPLETE!")
                        .font(GameFont.display(short ? 36 : 42))
                        .foregroundColor(GameTheme.navy)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                    StarRating(filled: store.save.stars(for: max(1, store.save.currentLevel - 1)), size: 40)
                        .padding(.top, 4)

                    Text("You made:")
                        .font(GameFont.headline(18))
                        .foregroundColor(GameTheme.navy.opacity(0.75))

                    foodRow

                    ChefCharacter(pose: .celebrating, size: short ? 120 : 140)

                    Spacer(minLength: 6)

                    CrazyButton(title: "NEXT LEVEL", icon: "arrow.right", kind: .next) {
                        store.startLevel(store.save.currentLevel)
                        router.go(.levelMap)
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
        .onAppear { AudioManager.shared.levelComplete() }
    }

    private var foodRow: some View {
        let foods = store.sessionCompleted.isEmpty ? store.currentLevel.requiredFoods : store.sessionCompleted
        return HStack(spacing: 14) {
            ForEach(foods, id: \.self) { food in
                VStack(spacing: 4) {
                    FoodIllustrationView(food: food, size: 52)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(GameTheme.successGreen)
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.85)))
    }
}

#Preview {
    LevelCompleteView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
