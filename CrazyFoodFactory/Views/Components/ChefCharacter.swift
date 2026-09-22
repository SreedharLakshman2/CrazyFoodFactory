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

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let bob = pose == .falling ? 8 : CGFloat(sin(t * 2.1)) * 4
            ArtImage(name: GameArt.chef(for: pose))
                .frame(width: size, height: size)
                .offset(y: bob)
                .rotationEffect(.degrees(pose == .falling ? -8 : 0))
                .animation(GameAnimations.chefReaction, value: pose)
        }
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
