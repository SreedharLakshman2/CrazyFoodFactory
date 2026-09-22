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
                    .padding(.top, 6)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: short ? 16 : 22) {
                            SpeechBubble(text: "What do you want\nto make today?")
                                .padding(.top, 12)
                                .padding(.bottom, 4)

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ],
                                spacing: 16
                            ) {
                                ForEach([FoodType.pizza, .burger, .iceCream, .donut], id: \.self) { food in
                                    FoodCard(food: food, artSize: short ? 104 : 118) { choose(food) }
                                        .overlay(alignment: .topTrailing) {
                                            if store.sessionCompleted.contains(food) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(GameTheme.successGreen)
                                                    .font(.title2)
                                                    .padding(12)
                                            }
                                        }
                                }
                            }

                            FoodCard(food: .sandwich, wide: true, artSize: short ? 112 : 128) {
                                choose(.sandwich)
                            }
                            .overlay(alignment: .topTrailing) {
                                if store.sessionCompleted.contains(.sandwich) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(GameTheme.successGreen)
                                        .font(.title2)
                                        .padding(12)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)
                    }
                }
                .factoryReadableWidth()
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
