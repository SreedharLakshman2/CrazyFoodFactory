import SwiftUI

struct FoodSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground(compact: true)

                VStack(spacing: short ? 12 : 18) {
                    HStack {
                        BackCircleButton { router.go(.home) }
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    SpeechBubble(text: "What do you want\nto make today?")

                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                        ForEach([FoodType.pizza, .burger, .iceCream, .donut], id: \.self) { food in
                            FoodCard(food: food) { choose(food) }
                                .overlay(alignment: .topTrailing) {
                                    if store.sessionCompleted.contains(food) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(GameTheme.successGreen)
                                            .font(.title2)
                                            .padding(10)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 18)

                    FoodCard(food: .sandwich, wide: true) { choose(.sandwich) }
                        .padding(.horizontal, 18)

                    Spacer(minLength: 8)
                }
                .padding(.top, 8)
            }
        }
        .statusBarHidden(true)
    }

    private func choose(_ food: FoodType) {
        store.select(food)
        router.go(.gameplay)
    }
}

#Preview {
    FoodSelectionView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
