import SwiftUI

struct FoodSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground(compact: true)

                VStack(spacing: 0) {
                    HStack {
                        BackCircleButton { router.go(.home) }
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)

                    SpeechBubble(text: "What do you want\nto make today?")
                        .padding(.top, 10)
                        .padding(.bottom, short ? 10 : 16)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(FoodKitchen.allCases) { kitchen in
                                kitchenSection(kitchen, short: short)
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 28)
                    }
                }
                .factoryReadableWidth()
            }
        }
        .statusBarHidden(true)
    }

    private func kitchenSection(_ kitchen: FoodKitchen, short: Bool) -> some View {
        let foods = FoodType.foods(in: kitchen)
        return VStack(alignment: .leading, spacing: 10) {
            Text(kitchen.title)
                .font(GameFont.headline(18))
                .foregroundColor(GameTheme.navy)
                .padding(.leading, 4)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 14),
                    GridItem(.flexible(), spacing: 14)
                ],
                spacing: 14
            ) {
                ForEach(foods) { food in
                    foodButton(food, artSize: short ? 86 : 98)
                }
            }
        }
    }

    private func foodButton(_ food: FoodType, artSize: CGFloat, wide: Bool = false) -> some View {
        FoodCard(food: food, wide: wide, artSize: artSize) { choose(food) }
            .overlay(alignment: .topTrailing) {
                if store.sessionCompleted.contains(food) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(GameTheme.successGreen)
                        .font(.title2)
                        .padding(12)
                }
            }
    }

    private func choose(_ food: FoodType) {
        store.select(food)
        AudioManager.shared.speakFood(food)
        router.go(.gameplay)
    }
}

#Preview {
    FoodSelectionView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
