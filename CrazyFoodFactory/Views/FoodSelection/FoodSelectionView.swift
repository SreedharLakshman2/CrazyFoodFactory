import SwiftUI

struct FoodSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    private let featured: [FoodType] = [.pizza, .burger, .iceCream, .donut]
    private let featuredWide: FoodType = .sandwich

    private var extra: [FoodType] {
        store.currentLevel.requiredFoods.filter { food in
            !featured.contains(food) && food != featuredWide
        }
    }

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
                        .padding(.top, 14)
                        .padding(.bottom, short ? 14 : 20)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ],
                                spacing: 16
                            ) {
                                ForEach(featured) { food in
                                    foodButton(food, artSize: short ? 98 : 112)
                                }
                            }

                            foodButton(featuredWide, artSize: short ? 110 : 124, wide: true)

                            if !extra.isEmpty {
                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible(), spacing: 16),
                                        GridItem(.flexible(), spacing: 16)
                                    ],
                                    spacing: 16
                                ) {
                                    ForEach(extra) { food in
                                        foodButton(food, artSize: short ? 90 : 102)
                                    }
                                }
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
