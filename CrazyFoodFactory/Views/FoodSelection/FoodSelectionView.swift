import SwiftUI

struct FoodSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground(compact: true)

                VStack(spacing: 0) {
                    HStack {
                        BackCircleButton { router.go(.home) }
                        Spacer()
                    }
                    .padding(.horizontal, 10)

                    SpeechBubble(text: "What do you want\nto make today?")
                        .padding(.top, 10)
                        .padding(.bottom, metrics.compact ? 10 : 16)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: metrics.pad ? 22 : 18) {
                            ForEach(FoodKitchen.allCases) { kitchen in
                                kitchenSection(kitchen, metrics: metrics)
                            }
                        }
                        .padding(.horizontal, metrics.pad ? 28 : 22)
                        .padding(.bottom, 28)
                    }
                }
                .factoryReadableWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
            }
            .factoryMetrics(metrics)
        }
        .statusBarHidden(true)
    }

    private func kitchenSection(_ kitchen: FoodKitchen, metrics: FactoryMetrics) -> some View {
        let foods = FoodType.foods(in: kitchen)
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: metrics.pad ? 16 : 14),
            count: metrics.pad && metrics.landscape == false ? 3 : 2
        )
        return VStack(alignment: .leading, spacing: 10) {
            Text(kitchen.title)
                .font(GameFont.headline(metrics.type(18, cap: 26)))
                .foregroundColor(GameTheme.navy)
                .padding(.leading, 4)
            LazyVGrid(columns: columns, spacing: metrics.pad ? 16 : 14) {
                ForEach(foods) { food in
                    foodButton(food, artSize: metrics.art(metrics.compact ? 86 : 98, cap: 128))
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
