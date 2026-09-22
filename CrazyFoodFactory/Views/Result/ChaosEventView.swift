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
                colors: [Color(hex: 0x7AD4FF), Color(hex: 0xB8ECFF)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ConfettiView(active: event.severity != .dramatic)
                .opacity(0.35)

            VStack(spacing: 10) {
                Text(event.title)
                    .font(GameFont.display(event.title.count > 18 ? 28 : 34))
                    .foregroundColor(GameTheme.comicRed)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)
                    .shadow(color: .white, radius: 0, y: 2)
                    .padding(.horizontal, 16)

                Text(event.subtitle)
                    .font(GameFont.title(26))
                    .foregroundColor(GameTheme.navy)

                Spacer(minLength: 8)

                ZStack {
                    scene
                }
                .frame(height: 280)

                Spacer(minLength: 8)

                if event.retry == .keepOrRetry {
                    CrazyButton(title: "KEEP IT CRAZY", icon: "sparkles", kind: .play, action: keep)
                        .padding(.horizontal, 28)
                }
                CrazyButton(
                    title: "TRY AGAIN",
                    icon: "arrow.clockwise",
                    kind: event.retry == .retryOnly ? .play : .retry,
                    action: retry
                )
                .padding(.horizontal, 28)
                .padding(.bottom, 12)
            }
            .padding(.top, 24)
        }
    }

    @ViewBuilder
    private var scene: some View {
        switch event.type {
        case .pineapplePizza:
            HStack(alignment: .bottom) {
                ChefCharacter(pose: .falling, size: 150)
                FoodIllustrationView(food: .pizza, placed: [.dough, .tomatoSauce, .cheese, .pineapple], size: 160)
            }
        case .meltedIceCream:
            ZStack {
                OvenArt(glowing: true, meltedInside: melted)
                    .frame(width: 210, height: 180)
                    .offset(y: -20)
                ChefCharacter(pose: .shocked, size: 120)
                    .offset(x: -120, y: 70)
            }
        case .penguinVisit:
            HStack(alignment: .bottom, spacing: 12) {
                PenguinArt().frame(width: 120, height: 150)
                FoodIllustrationView(food: food, size: 110)
                ChefCharacter(pose: .shocked, size: 120)
            }
        default:
            HStack(alignment: .bottom) {
                ChefCharacter(pose: event.severity == .dramatic ? .falling : .shocked, size: 140)
                FoodIllustrationView(food: food, melted: melted, size: 140)
            }
        }
    }
}

#Preview {
    ChaosEventView(event: .pineapplePizza, keep: {}, retry: {})
}
