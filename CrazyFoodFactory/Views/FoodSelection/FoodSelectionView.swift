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
                        VStack(spacing: short ? 10 : 14) {
                            FactoryLottie(name: .foodParade)
                                .frame(height: short ? 52 : 64)
                            SpeechBubble(text: "What do you want\nto make today?", compact: true)
                                .padding(.top, 2)
                            Text("9 yummy dishes • tap one to cook")
                                .font(GameFont.caption(14))
                                .foregroundColor(GameTheme.navy.opacity(0.7))

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10)
                                ],
                                spacing: 10
                            ) {
                                ForEach(FoodType.allCases) { food in
                                    FoodCard(food: food, artSize: short ? 64 : 72) { choose(food) }
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
