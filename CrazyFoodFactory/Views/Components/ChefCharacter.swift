import SwiftUI

enum ChefPose: Equatable {
    case idle
    case happy
    case cooking
    case shocked
    case falling
    case thumbsUp
    case celebrating
    case sad
}

struct ChefCharacter: View {
    var pose: ChefPose = .idle
    var size: CGFloat = 168
    var showsSpatula: Bool = false
    @State private var bob = false

    var body: some View {
        ArtImage(name: GameArt.chef(for: pose))
            .frame(width: size, height: size)
            .offset(y: pose == .falling ? 10 : (bob ? 4 : -3))
            .rotationEffect(.degrees(pose == .falling ? -8 : 0))
            .animation(GameAnimations.chefReaction, value: pose)
            .animation(
                pose == .falling
                    ? .default
                    : .easeInOut(duration: 1.15).repeatForever(autoreverses: true),
                value: bob
            )
            .onAppear { bob = true }
            .frame(width: size, height: size)
            .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        switch pose {
        case .idle, .cooking: return "Friendly cartoon chef"
        case .happy, .thumbsUp, .celebrating: return "Chef celebrating"
        case .shocked, .falling: return "Chef looking surprised"
        case .sad: return "Chef looking sorry"
        }
    }
}

#Preview {
    ZStack {
        GameTheme.skyGradient
        HStack {
            ChefCharacter(pose: .idle, showsSpatula: true)
            ChefCharacter(pose: .falling)
            ChefCharacter(pose: .happy)
        }
    }
}
