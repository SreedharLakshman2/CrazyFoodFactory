import SwiftUI

struct HowToPlayView: View {
    var onFinished: () -> Void
    @State private var page = 0

    private let pages: [Page] = [
        Page(
            title: "Kids learn by cooking!",
            body: "Tap ingredients in the right order. Little chefs practice steps, patience, names of foods, and trying again.",
            lottie: .foodParade
        ),
        Page(
            title: "Meet every ingredient",
            body: "Each veggie, fruit, and topping shows its name plus a tiny fact — so kids learn what they are eating.",
            lottie: .sprinkleRain
        ),
        Page(
            title: "Play anywhere, offline",
            body: "No internet needed. Nine yummy dishes, silly factory chaos, and Try Again anytime — even in the car!",
            lottie: .yumHearts
        )
    ]

    var body: some View {
        ZStack {
            FactoryBackground()

            VStack(spacing: 12) {
                HStack {
                    Text("How kids learn")
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                    Spacer()
                    Button("Skip") { finish() }
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 22)

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, item in
                        pageCard(item, index: index)
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
                .padding(.bottom, 16)
            }
            .factoryReadableWidth()
            .padding(.top, 10)
        }
        .statusBarHidden(true)
    }

    @ViewBuilder
    private func pageCard(_ item: Page, index: Int) -> some View {
        VStack(spacing: 14) {
            FactoryLottie(name: item.lottie)
                .frame(height: index == 1 ? 86 : 150)

            if index == 1 {
                HStack(spacing: 8) {
                    IngredientCard(ingredient: Ingredient(id: .tomato), compact: true, action: {})
                        .frame(width: 148)
                    IngredientCard(ingredient: Ingredient(id: .cheese), compact: true, action: {})
                        .frame(width: 148)
                }
                .allowsHitTesting(false)
            }

            Text(item.title)
                .font(GameFont.title(26))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.center)
            Text(item.body)
                .font(GameFont.body(16))
                .foregroundColor(GameTheme.navy.opacity(0.78))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white.opacity(0.94))
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    private func finish() {
        AudioManager.shared.success()
        onFinished()
    }

    private struct Page {
        let title: String
        let body: String
        let lottie: FactoryLottieName
    }
}

#Preview {
    HowToPlayView(onFinished: {})
}
