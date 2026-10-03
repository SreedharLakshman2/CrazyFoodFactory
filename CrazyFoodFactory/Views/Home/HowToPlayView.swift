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
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground()

                VStack(spacing: metrics.compact ? 12 : 18) {
                    HStack {
                        Spacer()
                        Button("Skip") { finish() }
                            .font(GameFont.headline(metrics.type(16, cap: 22)))
                            .foregroundColor(GameTheme.navy)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                    }
                    .padding(.horizontal, metrics.pad ? 28 : 20)

                    if metrics.pad && metrics.compact == false { Spacer(minLength: 8) }

                    pageCard(at: page, metrics: metrics)
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

                    HStack(spacing: metrics.pad ? 10 : 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == page ? GameTheme.navy : GameTheme.navy.opacity(0.22))
                                .frame(width: metrics.pad ? 10 : 8, height: metrics.pad ? 10 : 8)
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
                    .padding(.horizontal, metrics.pad ? 80 : 36)

                    if metrics.pad && metrics.compact == false { Spacer(minLength: 8) }
                }
                .factoryLandingWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
            }
            .factoryMetrics(metrics)
        }
        .statusBarHidden(true)
    }

    private func pageCard(at index: Int, metrics: FactoryMetrics) -> some View {
        let item = pages[index]
        return VStack(spacing: metrics.compact ? 16 : 24) {
            scene(for: item, index: index, metrics: metrics)
            Text(item.title)
                .font(GameFont.title(metrics.type(26, cap: 38)))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
            Text(item.body)
                .font(GameFont.body(metrics.type(17, cap: 24)))
                .foregroundColor(GameTheme.navy.opacity(0.72))
                .multilineTextAlignment(.center)
                .padding(.horizontal, metrics.pad ? 16 : 8)
            if index == 1 {
                schoolTeaser(metrics: metrics)
            }
        }
        .padding(metrics.compact ? 20 : (metrics.pad ? 32 : 22))
        .background(
            RoundedRectangle(cornerRadius: metrics.pad ? 40 : 32, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
        .padding(.horizontal, metrics.pad ? 40 : 22)
    }

    private func schoolTeaser(metrics: FactoryMetrics) -> some View {
        VStack(spacing: 10) {
            Text("Tomato is a juicy fruit used like a veggie. Chefs slice it for salsa and sandwiches.")
                .font(GameFont.caption(metrics.type(14, cap: 20)))
                .foregroundColor(GameTheme.navy.opacity(0.7))
                .multilineTextAlignment(.center)
            if onOpenSchool != nil {
                Button {
                    AudioManager.shared.tap()
                    onOpenSchool?()
                } label: {
                    Text("See ingredients!")
                        .font(GameFont.headline(metrics.type(16, cap: 22)))
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
    private func scene(for item: Page, index: Int, metrics: FactoryMetrics) -> some View {
        if index == 1 {
            HStack(spacing: metrics.pad ? 28 : 22) {
                IngredientCard(ingredient: Ingredient(id: .tomato), action: {})
                IngredientCard(ingredient: Ingredient(id: .cheese), action: {})
                IngredientCard(ingredient: Ingredient(id: .lettuce), action: {})
            }
            .allowsHitTesting(false)
            .frame(height: metrics.compact ? 120 : (metrics.pad ? 150 : 120))
        } else {
            ChefFoodStage(
                pose: index == 2 ? .celebrating : .idle,
                foods: item.foods,
                chefSize: metrics.art(metrics.compact ? 140 : 168, cap: metrics.pad ? 240 : 180),
                foodSize: metrics.art(64, cap: metrics.pad ? 92 : 72)
            )
            .frame(height: metrics.compact ? 200 : (metrics.pad ? 280 : 220))
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
