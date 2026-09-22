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

            VStack(spacing: 10) {
                if event.type == .penguinVisit {
                    WarningBanner(text: event.title)
                        .padding(.horizontal, 20)
                        .padding(.top, 18)
                } else {
                    Text(event.title)
                        .font(GameFont.display(event.title.count > 18 ? 32 : 38))
                        .foregroundColor(GameTheme.comicRed)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.68)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)

                    Text(event.subtitle)
                        .font(GameFont.title(30))
                        .foregroundColor(GameTheme.navy)
                }

                Spacer(minLength: 4)

                scene
                    .frame(maxHeight: 340)

                Spacer(minLength: 4)

                if event.retry == .keepOrRetry {
                    CrazyButton(title: "KEEP IT CRAZY", icon: "sparkles", kind: .play, action: keep)
                        .factoryButtonWidth()
                        .padding(.horizontal, 36)
                }

                CrazyButton(
                    title: event.retry == .continuePlay ? "OOPS!" : "TRY AGAIN",
                    icon: event.retry == .continuePlay ? "face.smiling" : "arrow.clockwise",
                    kind: .retry,
                    action: retry
                )
                .factoryButtonWidth()
                .padding(.horizontal, 36)
                .padding(.bottom, 20)
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
            return [Color(hex: 0x6AD0FF), Color(hex: 0xD6F3FF), Color.white]
        }
    }

    @ViewBuilder
    private var scene: some View {
        switch event.type {
        case .pineapplePizza:
            HStack(alignment: .center, spacing: -8) {
                ChefCharacter(pose: .falling, size: 230)
                FoodIllustrationView(food: .pizza, placed: [.pineapple], size: 210)
            }
            .padding(.horizontal, 4)
        case .meltedIceCream:
            ZStack(alignment: .bottom) {
                OvenArt(glowing: true, meltedInside: true)
                    .frame(width: 250, height: 250)
                    .offset(y: -18)
                ChefCharacter(pose: .shocked, size: 148)
                    .offset(x: -118, y: 18)
            }
            .frame(height: 300)
        case .penguinVisit:
            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.white.opacity(0.92))
                    .frame(height: 28)
                    .padding(.horizontal, 36)
                    .offset(y: -8)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 3)
                HStack(alignment: .bottom, spacing: 10) {
                    PenguinArt().frame(width: 150, height: 176)
                    FoodIllustrationView(food: food, size: 128)
                }
                .padding(.bottom, 18)
            }
            .frame(height: 220)
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
