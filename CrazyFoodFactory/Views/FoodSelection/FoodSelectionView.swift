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
                        .padding(.bottom, short ? 12 : 18)

                    ScrollView(showsIndicators: false) {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(gridFoods) { food in
                                foodButton(food, artSize: short ? 96 : 108)
                            }
                        }

                        if let last = trailingFood {
                            foodButton(last, artSize: short ? 108 : 120, wide: true)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 24)
                }
                .factoryReadableWidth()
            }
        }
        .statusBarHidden(true)
    }

    private var foods: [FoodType] { FoodType.allCases }
    private var trailingFood: FoodType? { foods.count.isMultiple(of: 2) ? nil : foods.last }
    private var gridFoods: [FoodType] {
        guard trailingFood != nil else { return foods }
        return Array(foods.dropLast())
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
        router.go(.gameplay)
    }
}

#Preview {
    FoodSelectionView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
