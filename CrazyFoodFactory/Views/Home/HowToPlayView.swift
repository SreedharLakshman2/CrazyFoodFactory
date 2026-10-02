import SwiftUI

struct HowToPlayView: View {
    var onFinished: () -> Void
    var onOpenSchool: (() -> Void)? = nil
    @State private var page = 0

    private let pages: [Page] = [
        Page(
            title: "Kids learn by cooking!",
            body: "Tap foods in the right order. Little chefs practice steps, patience, and trying again.",
            foods: [.pizza, .dosa, .taco, .burger]
        ),
        Page(
            title: "Meet every ingredient",
            body: "Open Ingredient School to learn what each food is and how chefs use it — tomato, paneer, mango, and more.",
            foods: [.sandwich, .idli]
        ),
        Page(
            title: "Kitchens around the world",
            body: "Cook South Indian, Indian, Mexican, and classic treats. All offline — even in the car!",
            foods: [.biryani, .burrito, .mangoLassi]
        )
    ]

    var body: some View {
        GeometryReader { geo in
            let pad = FactoryLayout.isRegular(geo.size)
            let scale = FactoryLayout.scale(in: geo.size)
            ZStack {
                FactoryBackground()

                VStack(spacing: pad ? 18 : 12) {
                    HStack {
                        Spacer()
                        Button("Skip") { finish() }
                            .font(GameFont.headline(pad ? 18 : 16))
                            .foregroundColor(GameTheme.navy)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                    }
                    .padding(.horizontal, pad ? 28 : 20)

                    if pad { Spacer(minLength: 8) }

                    pageCard(at: page, scale: scale, pad: pad)
                        .id(page)
                        .gesture(
                            DragGesture(minimumDistance: 48).onEnded { value in
                                if value.translation.width < -48, page < pages.count - 1 {
                                    withAnimation { page += 1 }
                                } else if value.translation.width > 48, page > 0 {
                                    withAnimation { page -= 1 }
                                }
                            }
                        )

                    HStack(spacing: pad ? 10 : 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == page ? GameTheme.navy : GameTheme.navy.opacity(0.22))
                                .frame(width: pad ? 10 : 8, height: pad ? 10 : 8)
                        }
                    }
                    .padding(.top, 4)

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
                    .padding(.horizontal, pad ? 80 : 36)
                    .padding(.bottom, pad ? 28 : 18)

                    if pad { Spacer(minLength: 8) }
                }
                .factoryLandingWidth()
                .padding(.top, 8)
            }
        }
        .statusBarHidden(true)
    }

    private func pageCard(at index: Int, scale: CGFloat, pad: Bool) -> some View {
        let item = pages[index]
        return VStack(spacing: pad ? 24 : 18) {
            scene(for: item, index: index, scale: scale, pad: pad)
            Text(item.title)
                .font(GameFont.title(min(26 * scale, 36)))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
            Text(item.body)
                .font(GameFont.body(min(17 * scale, 22)))
                .foregroundColor(GameTheme.navy.opacity(0.72))
                .multilineTextAlignment(.center)
                .padding(.horizontal, pad ? 16 : 8)
            if index == 1 {
                schoolTeaser(scale: scale)
            }
        }
        .padding(pad ? 32 : 22)
        .background(
            RoundedRectangle(cornerRadius: pad ? 40 : 32, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
        .padding(.horizontal, pad ? 40 : 22)
    }

    private func schoolTeaser(scale: CGFloat) -> some View {
        VStack(spacing: 10) {
            Text("Tomato is a juicy fruit used like a veggie. Chefs slice it for salsa and sandwiches.")
                .font(GameFont.caption(min(14 * scale, 17)))
                .foregroundColor(GameTheme.navy.opacity(0.7))
                .multilineTextAlignment(.center)
            if onOpenSchool != nil {
                Button {
                    AudioManager.shared.tap()
                    onOpenSchool?()
                } label: {
                    Text("See ingredients!")
                        .font(GameFont.headline(min(16 * scale, 20)))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color(hex: 0xFF8A3D)))
                }
                .buttonStyle(PressScaleStyle())
                .accessibilityLabel("See ingredients")
            }
        }
    }

    @ViewBuilder
    private func scene(for item: Page, index: Int, scale: CGFloat, pad: Bool) -> some View {
        if index == 1 {
            HStack(spacing: pad ? 28 : 22) {
                IngredientCard(ingredient: Ingredient(id: .tomato), action: {})
                IngredientCard(ingredient: Ingredient(id: .cheese), action: {})
                IngredientCard(ingredient: Ingredient(id: .lettuce), action: {})
            }
            .allowsHitTesting(false)
            .scaleEffect(pad ? 1.2 : 1)
            .frame(height: pad ? 150 : 120)
        } else {
            let chef = min(max(150 * scale, pad ? 220 : 150), pad ? 280 : 200)
            let food = min(58 * scale, pad ? 96 : 72)
            let spread = chef / 150
            ZStack {
                ChefCharacter(pose: index == 2 ? .celebrating : .idle, size: chef, showsSpatula: true)
                ForEach(Array(item.foods.enumerated()), id: \.element) { i, foodType in
                    FoodIllustrationView(food: foodType, size: food)
                        .offset(
                            x: CGFloat([-110, 110, -90, 96][i % 4]) * spread,
                            y: CGFloat([-20, -8, 56, 64][i % 4]) * spread
                        )
                }
            }
            .frame(height: chef + 50 * spread)
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

#Preview("iPhone") {
    HowToPlayView(onFinished: {})
}

#Preview("iPad") {
    HowToPlayView(onFinished: {})
}
