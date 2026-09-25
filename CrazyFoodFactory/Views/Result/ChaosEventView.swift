import SwiftUI

struct ChaosEventView: View {
    let event: ChaosEvent
    var food: FoodType = .pizza
    var melted: Bool = false
    var keep: () -> Void
    var retry: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: chaosColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                if event.type == .penguinVisit {
                    WarningBanner(text: "Oops! A little chaos!")
                        .padding(.horizontal, 22)
                        .padding(.top, 20)
                } else {
                    Text(event.title)
                        .font(GameFont.display(event.title.count > 18 ? 34 : 40))
                        .foregroundColor(GameTheme.comicRed)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 16)
                        .padding(.top, 28)
                    Text(event.subtitle)
                        .font(GameFont.title(28))
                        .foregroundColor(GameTheme.navy)
                }

                Spacer(minLength: 8)
                scene
                Spacer(minLength: 8)

                if event.retry == .keepOrRetry {
                    CrazyButton(title: "KEEP IT CRAZY", icon: "sparkles", kind: .play, action: keep)
                        .factoryButtonWidth()
                        .padding(.horizontal, 36)
                }

                CrazyButton(
                    title: event.retry == .continuePlay ? "OOPS!" : "TRY AGAIN",
                    icon: "arrow.clockwise",
                    kind: .retry,
                    action: retry
                )
                .factoryButtonWidth()
                .padding(.horizontal, 36)
                .padding(.bottom, 22)
            }
            .factoryReadableWidth()
        }
    }

    private var chaosColors: [Color] {
        switch event.type {
        case .meltedIceCream:
            return [Color(hex: 0xFF8A73), Color(hex: 0xFFD3C4), Color(hex: 0xFFF4EC)]
        case .penguinVisit:
            return [Color(hex: 0x7AD4FF), Color(hex: 0xD7F2FF), Color.white]
        default:
            return [Color(hex: 0x8BDCFF), Color(hex: 0xD6F3FF), Color.white]
        }
    }

    @ViewBuilder
    private var scene: some View {
        switch event.type {
        case .pineapplePizza:
            VStack(spacing: 8) {
                ChefCharacter(pose: .falling, size: 210)
                FoodIllustrationView(food: .pizza, placed: [.pineapple], size: 220)
            }
        case .meltedIceCream:
            ZStack(alignment: .bottom) {
                OvenArt(glowing: true, meltedInside: true)
                    .frame(width: 300, height: 300)
                ChefCharacter(pose: .shocked, size: 140)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                    .offset(y: 16)
            }
            .frame(height: 340)
        case .penguinVisit:
            VStack(spacing: 10) {
                HStack(alignment: .bottom, spacing: 18) {
                    PenguinArt().frame(width: 170, height: 196)
                    FoodIllustrationView(food: food, size: 140)
                }
                Text("Oops!")
                    .font(GameFont.title(34))
                    .foregroundColor(GameTheme.navy)
            }
        default:
            HStack(alignment: .bottom, spacing: 8) {
                ChefCharacter(pose: event.severity == .dramatic ? .falling : .shocked, size: 168)
                FoodIllustrationView(food: food, melted: melted, size: 156)
            }
        }
    }
}

#Preview {
    ChaosEventView(event: .pineapplePizza, keep: {}, retry: {})
}
