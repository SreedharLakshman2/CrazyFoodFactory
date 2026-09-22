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
            let blink = Int(t * 2.1) % 19 == 0
            let bob = pose == .falling ? 6 : CGFloat(sin(t * 2.2)) * 4
            let tilt: Double = {
                switch pose {
                case .falling: return -26
                case .shocked: return -6
                case .celebrating: return sin(t * 5.5) * 7
                default: return 0
                }
            }()
            ChefDrawing(pose: pose, blink: blink, showsSpatula: showsSpatula)
                .frame(width: size, height: size * 1.35)
                .rotationEffect(.degrees(tilt))
                .offset(x: pose == .falling ? 16 : 0, y: bob)
                .animation(GameAnimations.chefReaction, value: pose)
        }
        .frame(width: size, height: size * 1.35)
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

private struct ChefDrawing: View {
    var pose: ChefPose
    var blink: Bool
    var showsSpatula: Bool

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Ellipse()
                    .fill(Color.black.opacity(0.14))
                    .frame(width: w * 0.46, height: h * 0.07)
                    .offset(y: h * 0.46)

                legs(w: w, h: h)
                coat(w: w, h: h)
                arms(w: w, h: h)
                scarf(w: w, h: h)
                head(w: w, h: h)
                if showsSpatula || pose == .idle || pose == .cooking {
                    spatula(w: w, h: h)
                }
            }
            .frame(width: w, height: h)
        }
    }

    private func legs(w: CGFloat, h: CGFloat) -> some View {
        HStack(spacing: w * 0.08) {
            Capsule().fill(Color(hex: 0x2C3E50)).frame(width: w * 0.13, height: h * 0.2)
            Capsule().fill(Color(hex: 0x2C3E50)).frame(width: w * 0.13, height: h * 0.2)
        }
        .offset(y: h * 0.36)
        .overlay(alignment: .bottom) {
            HStack(spacing: w * 0.08) {
                Capsule().fill(Color.white).frame(width: w * 0.16, height: h * 0.07)
                Capsule().fill(Color.white).frame(width: w * 0.16, height: h * 0.07)
            }
            .offset(y: h * 0.12)
        }
    }

    private func coat(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: w * 0.22, style: .continuous)
                .fill(
                    LinearGradient(colors: [Color.white, Color(hex: 0xEEF3F8)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: w * 0.52, height: h * 0.34)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 3)
            VStack(spacing: 7) {
                Circle().fill(Color(hex: 0xCFD8DC)).frame(width: 8, height: 8)
                Circle().fill(Color(hex: 0xCFD8DC)).frame(width: 8, height: 8)
                Circle().fill(Color(hex: 0xCFD8DC)).frame(width: 8, height: 8)
            }
            .offset(y: h * 0.02)
        }
        .offset(y: h * 0.16)
    }

    private func scarf(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(colors: [Color(hex: 0xFF5A5A), Color(hex: 0xD32F2F)], startPoint: .top, endPoint: .bottom))
                .frame(width: w * 0.36, height: h * 0.075)
            Capsule()
                .fill(Color(hex: 0xC62828))
                .frame(width: w * 0.1, height: h * 0.1)
                .offset(y: h * 0.04)
        }
        .offset(y: h * 0.03)
    }

    private func arms(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            if pose == .shocked || pose == .falling || pose == .celebrating {
                Capsule().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.12, height: h * 0.2)
                    .rotationEffect(.degrees(-48))
                    .offset(x: -w * 0.32, y: -h * 0.02)
                Capsule().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.12, height: h * 0.2)
                    .rotationEffect(.degrees(48))
                    .offset(x: w * 0.32, y: -h * 0.02)
            } else if pose == .thumbsUp {
                Capsule().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.11, height: h * 0.18)
                    .offset(x: -w * 0.28, y: h * 0.12)
                Circle().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.16, height: w * 0.16)
                    .overlay(Circle().stroke(Color(hex: 0xE2A07C), lineWidth: 1))
                    .offset(x: w * 0.32, y: 0)
            } else {
                Capsule().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.11, height: h * 0.18)
                    .offset(x: -w * 0.28, y: h * 0.12)
                Capsule().fill(Color(hex: 0xF7C7A5)).frame(width: w * 0.11, height: h * 0.18)
                    .offset(x: w * 0.28, y: h * 0.12)
            }
        }
    }

    private func head(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: 0x5D4037))
                .frame(width: w * 0.46, height: h * 0.14)
                .offset(y: -h * 0.1)
            Circle()
                .fill(
                    LinearGradient(colors: [Color(hex: 0xFFE0C2), Color(hex: 0xF3B48A)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: w * 0.54, height: w * 0.54)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 3)
                .offset(y: -h * 0.15)
            chefHat(w: w, h: h)
            Circle().fill(Color(hex: 0xFF8A80).opacity(0.75)).frame(width: w * 0.1, height: w * 0.075)
                .offset(x: -w * 0.17, y: -h * 0.11)
            Circle().fill(Color(hex: 0xFF8A80).opacity(0.75)).frame(width: w * 0.1, height: w * 0.075)
                .offset(x: w * 0.17, y: -h * 0.11)
            eye(open: !blink, w: w).offset(x: -w * 0.11, y: -h * 0.175)
            eye(open: !blink, w: w).offset(x: w * 0.11, y: -h * 0.175)
            mouth(w: w, h: h)
        }
    }

    private func chefHat(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            Capsule()
                .fill(Color.white)
                .frame(width: w * 0.46, height: h * 0.085)
                .offset(y: -h * 0.34)
                .shadow(color: .black.opacity(0.08), radius: 2, y: 2)
            Circle()
                .fill(LinearGradient(colors: [Color.white, Color(hex: 0xF0F4F8)], startPoint: .top, endPoint: .bottom))
                .frame(width: w * 0.42, height: w * 0.42)
                .offset(y: -h * 0.46)
            Circle()
                .fill(Color.white)
                .frame(width: w * 0.22, height: w * 0.22)
                .offset(x: w * 0.12, y: -h * 0.52)
        }
    }

    private func eye(open: Bool, w: CGFloat) -> some View {
        ZStack {
            if open {
                Circle().fill(Color.white).frame(width: w * 0.14, height: w * 0.16)
                    .shadow(color: .black.opacity(0.08), radius: 1, y: 1)
                Circle().fill(Color(hex: 0x4E342E)).frame(width: w * 0.08, height: w * 0.09)
                Circle().fill(Color.white).frame(width: w * 0.03, height: w * 0.03).offset(x: 3, y: -3)
            } else {
                Capsule().fill(Color(hex: 0x4E342E)).frame(width: w * 0.12, height: 3)
            }
        }
    }

    @ViewBuilder
    private func mouth(w: CGFloat, h: CGFloat) -> some View {
        switch pose {
        case .shocked, .falling:
            Capsule().fill(Color(hex: 0xC62828)).frame(width: w * 0.13, height: h * 0.1).offset(y: -h * 0.08)
        case .sad:
            Capsule().stroke(Color(hex: 0xC62828), lineWidth: 3).frame(width: w * 0.12, height: 10)
                .rotationEffect(.degrees(180)).offset(y: -h * 0.07)
        case .happy, .celebrating, .thumbsUp:
            Capsule().fill(Color(hex: 0xC62828)).frame(width: w * 0.18, height: 8).offset(y: -h * 0.08)
        default:
            Capsule().fill(Color(hex: 0xE07A6A)).frame(width: w * 0.11, height: 6).offset(y: -h * 0.08)
        }
    }

    private func spatula(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            Capsule().fill(Color(hex: 0x8D6E63)).frame(width: 9, height: h * 0.28)
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(colors: [Color(hex: 0xECEFF1), Color(hex: 0x90A4AE)], startPoint: .top, endPoint: .bottom))
                .frame(width: w * 0.18, height: h * 0.1)
                .offset(y: -h * 0.16)
        }
        .offset(x: w * 0.36, y: h * 0.04)
        .rotationEffect(.degrees(16))
    }
}

#Preview {
    ZStack {
        GameTheme.skyGradient
        HStack {
            ChefCharacter(pose: .idle, showsSpatula: true)
            ChefCharacter(pose: .falling)
        }
    }
}
