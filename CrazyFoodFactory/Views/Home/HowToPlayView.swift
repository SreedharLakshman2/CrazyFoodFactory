import SwiftUI

struct HowToPlayView: View {
    var onFinished: () -> Void
    @State private var page = 0

    private let pages: [Page] = [
        Page(
            title: "Kids learn by cooking!",
            body: "Tap foods in the right order. Little chefs practice steps, patience, and trying again.",
            foods: [.pizza, .taco, .burger, .cupcake]
        ),
        Page(
            title: "Meet every ingredient",
            body: "Each veggie and topping has a name and a tiny fact, so kids learn what they are eating.",
            foods: [.sandwich, .donut]
        ),
        Page(
            title: "Play anywhere, offline",
            body: "No internet needed. Thirteen yummy dishes and silly kitchen chaos — even in the car!",
            foods: [.pasta, .hotDog, .iceCream]
        )
    ]

    var body: some View {
        ZStack {
            FactoryBackground()

            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Button("Skip") { finish() }
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal, 20)

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: 18) {
                            scene(for: item, index: index)
                            Text(item.title)
                                .font(GameFont.title(28))
                                .foregroundColor(GameTheme.navy)
                                .multilineTextAlignment(.center)
                            Text(item.body)
                                .font(GameFont.body(17))
                                .foregroundColor(GameTheme.navy.opacity(0.72))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        }
                        .padding(22)
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
                        .padding(.horizontal, 22)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                CrazyButton(
                    title: page == pages.count - 1 ? "LET'S COOK!" : "NEXT",
                    icon: page == pages.count - 1 ? "fork.knife" : "arrow.right"
                ) {
                    if page == pages.count - 1 {
                        finish()
                    } else {
                        withAnimation { page += 1 }
                    }
                }
                .factoryButtonWidth()
                .padding(.horizontal, 36)
                .padding(.bottom, 18)
            }
            .factoryReadableWidth()
            .padding(.top, 8)
        }
        .statusBarHidden(true)
    }

    @ViewBuilder
    private func scene(for item: Page, index: Int) -> some View {
        if index == 1 {
            HStack(spacing: 22) {
                IngredientCard(ingredient: Ingredient(id: .tomato), action: {})
                IngredientCard(ingredient: Ingredient(id: .cheese), action: {})
                IngredientCard(ingredient: Ingredient(id: .lettuce), action: {})
            }
            .allowsHitTesting(false)
            .frame(height: 120)
        } else {
            ZStack {
                ChefCharacter(pose: index == 2 ? .celebrating : .idle, size: 150, showsSpatula: true)
                ForEach(Array(item.foods.enumerated()), id: \.element) { i, food in
                    FoodIllustrationView(food: food, size: 58)
                        .offset(
                            x: CGFloat([-110, 110, -90, 96][i % 4]),
                            y: CGFloat([-20, -8, 56, 64][i % 4])
                        )
                }
            }
            .frame(height: 190)
        }
    }

    private func finish() {
        AudioManager.shared.success()
        onFinished()
    }

    private struct Page {
        let title: String
        let body: String
        let foods: [FoodType]
    }
}

#Preview {
    HowToPlayView(onFinished: {})
}
