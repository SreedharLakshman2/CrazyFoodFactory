import SwiftUI

struct CrazyButton: View {
    var title: String
    var icon: String? = nil
    var kind: Kind = .play
    var fillsWidth: Bool = true
    var action: () -> Void

    enum Kind {
        case play, next, retry, home, danger
    }

    var body: some View {
        Button(action: {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        }) {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .heavy))
                }
                Text(title)
                    .font(GameFont.title(kind == .play ? 28 : 22))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(foreground)
            .padding(.horizontal, 28)
            .frame(maxWidth: fillsWidth ? .infinity : nil)
            .frame(height: kind == .play ? 68 : 60)
            .background(background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.55), lineWidth: 3)
            )
            .overlay(alignment: .top) {
                Capsule()
                    .fill(Color.white.opacity(0.28))
                    .frame(height: 10)
                    .padding(.horizontal, 22)
                    .padding(.top, 8)
            }
            .shadow(color: shadow.opacity(0.35), radius: 0, y: 5)
            .shadow(color: Color.black.opacity(0.16), radius: 10, y: 8)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(title)
    }

    private var foreground: Color {
        kind == .retry || kind == .home ? GameTheme.darkText : .white
    }

    private var shadow: Color {
        switch kind {
        case .play, .next: return Color(hex: 0x0E8A42)
        case .retry, .home: return Color(hex: 0x90A4AE)
        case .danger: return GameTheme.dangerRed
        }
    }

    @ViewBuilder
    private var background: some View {
        switch kind {
        case .play, .next:
            GameTheme.playGradient
        case .retry, .home:
            LinearGradient(colors: [Color.white, Color(hex: 0xF4F7FB)], startPoint: .top, endPoint: .bottom)
        case .danger:
            LinearGradient(colors: [Color(hex: 0xFF6B5A), Color(hex: 0xE53935)], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct CircleIconButton: View {
    var systemName: String
    var accessibility: String
    var dimmed: Bool = false
    var action: () -> Void

    var body: some View {
        Button {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(GameTheme.navy.opacity(dimmed ? 0.35 : 1))
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.12), radius: 6, y: 3)
                )
                .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 2))
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(accessibility)
    }
}

struct SettingsButton: View {
    var action: () -> Void
    var body: some View {
        CircleIconButton(systemName: "gearshape.fill", accessibility: "Settings", action: action)
    }
}

struct PauseButton: View {
    var action: () -> Void
    var body: some View {
        CircleIconButton(systemName: "pause.fill", accessibility: "Pause", action: action)
    }
}

struct BackCircleButton: View {
    var action: () -> Void
    var body: some View {
        CircleIconButton(systemName: "chevron.left", accessibility: "Back", action: action)
    }
}

struct SpeechBubble: View {
    var text: String
    var compact: Bool = false

    var body: some View {
        Text(text)
            .font(GameFont.headline(compact ? 17 : 23))
            .foregroundColor(GameTheme.navy)
            .multilineTextAlignment(.center)
            .padding(.horizontal, compact ? 16 : 22)
            .padding(.vertical, compact ? 11 : 16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, Color(hex: 0xEAF7FF), Color(hex: 0xFFF4D6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
            )
            .overlay(alignment: .bottomLeading) {
                BubbleTail()
                    .fill(Color.white)
                    .frame(width: 18, height: 14)
                    .offset(x: 22, y: 8)
            }
            .id(text)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.42, dampingFraction: 0.7), value: text)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + 4, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct StarRating: View {
    var filled: Int
    var total: Int = 3
    var size: CGFloat = 28

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: size, weight: .bold))
                    .foregroundColor(i < filled ? GameTheme.primaryYellow : Color.white.opacity(0.45))
                    .shadow(color: Color.orange.opacity(i < filled ? 0.35 : 0), radius: 3, y: 1)
            }
        }
        .accessibilityLabel("\(filled) of \(total) stars")
    }
}

struct ProgressStars: View {
    var filled: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < filled ? "star.fill" : "star")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(i < filled ? GameTheme.primaryYellow : Color.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Capsule().fill(Color.white.opacity(0.22)))
        .accessibilityLabel("Progress \(filled) stars")
    }
}

struct FoodCard: View {
    let food: FoodType
    var wide: Bool = false
    var artSize: CGFloat = 112
    var action: () -> Void

    var body: some View {
        Button {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        } label: {
            VStack(spacing: 10) {
                FoodIllustrationView(food: food, size: artSize)
                Text(food.displayName)
                    .font(GameFont.headline(wide ? 20 : 17))
                    .foregroundColor(GameTheme.navy)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, wide ? 22 : 18)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(food.cardColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.95), lineWidth: 3)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 10, y: 6)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(food.displayName)
    }
}

struct IngredientCard: View {
    let ingredient: Ingredient
    var used: Bool = false
    var compact: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                IngredientArt(id: ingredient.id)
                    .frame(width: compact ? 58 : 64, height: compact ? 58 : 64)
                    .opacity(used ? 0.45 : 1)
                Text(ingredient.displayName)
                    .font(GameFont.caption(11))
                    .foregroundColor(GameTheme.navy)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: compact ? 64 : 70)
            }
            .opacity(used && !ingredient.isOptional ? 0.7 : 1)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel("\(ingredient.displayName). \(ingredient.kidFact)")
    }
}

struct IngredientTray: View {
    let ingredients: [Ingredient]
    let placed: [IngredientID]
    var compact: Bool = false
    var onTap: (IngredientID) -> Void

    var body: some View {
        let cards = HStack(spacing: compact ? 8 : 10) {
            ForEach(ingredients) { item in
                IngredientCard(
                    ingredient: item,
                    used: placed.contains(item.id) && !item.isOptional && !item.isChaosBait,
                    compact: compact
                ) {
                    onTap(item.id)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)

        Group {
            if ingredients.count <= 5 {
                cards
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    cards
                }
                .scrollClipDisabled()
            }
        }
        .accessibilityElement(children: .contain)
    }
}

struct LearnFactBanner: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(GameTheme.primaryYellow)
            Text(text)
                .font(GameFont.caption(14))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xFFF6D4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.black.opacity(0.08), radius: 6, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white, lineWidth: 2)
        )
        .padding(.horizontal, 16)
        .accessibilityLabel(text)
    }
}

struct TitleChip: View {
    var food: FoodType
    var title: String

    var body: some View {
        HStack(spacing: 8) {
            FoodIllustrationView(food: food, size: 28)
            Text(title)
                .font(GameFont.headline(16))
                .foregroundColor(GameTheme.navy)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xE8F7FF), Color(hex: 0xFFF4D6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
        .overlay(Capsule().stroke(Color.white, lineWidth: 2))
        .shadow(color: Color.black.opacity(0.1), radius: 6, y: 3)
        .accessibilityLabel(title)
    }
}

struct SparkleEffect: View {
    var tick: Int

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { _ in
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Image(systemName: "sparkle")
                        .font(.system(size: 12 + CGFloat(i % 3) * 3, weight: .bold))
                        .foregroundColor(GameTheme.primaryYellow)
                        .offset(
                            x: cos(Double(i) / 8 * .pi * 2 + Double(tick)) * 46,
                            y: sin(Double(i) / 8 * .pi * 2 + Double(tick)) * 36
                        )
                        .opacity(tick == 0 ? 0 : 1)
                }
            }
            .allowsHitTesting(false)
        }
        .animation(GameAnimations.successPop, value: tick)
    }
}

struct ConfettiView: View {
    var active: Bool = true

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24, paused: !active)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { geo in
                ForEach(0..<22, id: \.self) { i in
                    let x = CGFloat((i * 37) % 100) / 100 * geo.size.width
                    let fall = CGFloat((t * (0.25 + Double(i % 5) * 0.08) + Double(i)).truncatingRemainder(dividingBy: 1.4))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(colors[i % colors.count])
                        .frame(width: 8, height: 12)
                        .rotationEffect(.degrees(t * 80 + Double(i) * 12))
                        .position(x: x, y: fall * geo.size.height)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var colors: [Color] {
        [GameTheme.primaryYellow, GameTheme.pizzaRed, GameTheme.playGreen, GameTheme.donutPink, GameTheme.factoryBlue, GameTheme.orange]
    }
}

struct LevelNode: View {
    let level: LevelDefinition
    var unlocked: Bool
    var completed: Bool
    var current: Bool
    var stars: Int
    var action: () -> Void

    var body: some View {
        Button(action: {
            guard unlocked else { return }
            AudioManager.shared.tap()
            action()
        }) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(unlocked ? Color.white : GameTheme.lockBlue.opacity(0.55))
                        .frame(width: 80, height: 80)
                        .overlay(Circle().stroke(unlocked ? level.nodeFood.accent : Color.white.opacity(0.4), lineWidth: 4))
                        .shadow(color: Color.black.opacity(unlocked ? 0.12 : 0.05), radius: 6, y: 4)
                    FoodIllustrationView(food: level.nodeFood, size: 48)
                        .opacity(unlocked ? 1 : 0.28)
                    if !unlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(GameTheme.navy.opacity(0.7))
                    }
                    Text("\(level.id)")
                        .font(GameFont.caption(12))
                        .foregroundColor(GameTheme.navy)
                        .padding(5)
                        .background(Circle().fill(Color.white))
                        .offset(x: -26, y: -26)
                }
                .pulsing(current && unlocked)
                if completed {
                    StarRating(filled: stars, size: 10)
                }
            }
        }
        .buttonStyle(PressScaleStyle())
        .disabled(!unlocked)
        .accessibilityLabel(unlocked ? "Level \(level.id) \(level.title)" : "Level \(level.id) locked")
    }
}

struct ResultCard: View {
    let result: FoodResult

    var body: some View {
        VStack(spacing: 14) {
            ForEach(checklist, id: \.self) { item in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(GameTheme.successGreen)
                        .font(.system(size: 22, weight: .bold))
                    Text(item.displayName)
                        .font(GameFont.headline(18))
                        .foregroundColor(GameTheme.navy)
                    Spacer()
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xF3FBFF)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white, lineWidth: 2)
        )
        .softCardShadow()
    }

    private var checklist: [IngredientID] {
        let defined = FoodCatalog.definition(for: result.food, level: LevelCatalog.level(1)).checklist
            .filter { $0 != .dough && $0 != .donutBase }
        if !defined.isEmpty { return Array(defined.prefix(4)) }
        let fallback = result.placed.filter { $0 != .dough && $0 != .donutBase }
        return Array((fallback.isEmpty ? result.placed : fallback).prefix(4))
    }
}

struct RibbonTitle: View {
    var text: String

    var body: some View {
        AnimatedTextBanner(
            text: text,
            colors: [Color(hex: 0xFFE56A), Color(hex: 0xFFC93A), Color(hex: 0xFF9A3C)],
            size: 30
        )
        .overlay(alignment: .leading) {
            Circle()
                .fill(Color(hex: 0xF4B430))
                .frame(width: 18, height: 18)
                .offset(x: 10)
        }
        .overlay(alignment: .trailing) {
            Circle()
                .fill(Color(hex: 0xF4B430))
                .frame(width: 18, height: 18)
                .offset(x: -10)
        }
        .padding(.horizontal, 22)
    }
}

struct HomeCircleButton: View {
    var action: () -> Void
    var body: some View {
        CircleIconButton(systemName: "house.fill", accessibility: "Home", action: action)
    }
}

struct WarningBanner: View {
    var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: 0xFFC107))
            Text(text)
                .font(GameFont.headline(18))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
    }
}

struct FactoryTable: View {
    var body: some View {
        Ellipse()
            .fill(Color.white.opacity(0.96))
            .overlay(
                Ellipse()
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 16, y: 8)
            .accessibilityHidden(true)
    }
}

struct FrostingPipe: View {
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0xE7EDF3), Color(hex: 0xB7C0CB), Color(hex: 0x9AA6B4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 16, height: 150)
            Capsule()
                .fill(Color(hex: 0x8E9AAB))
                .frame(width: 36, height: 20)
            Capsule()
                .fill(Color(hex: 0xFF8AD4))
                .frame(width: 10, height: 14)
                .offset(y: -2)
        }
        .accessibilityHidden(true)
    }
}

struct FactoryArm: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(hex: 0x8A97A8))
                    .frame(width: 86, height: 22)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(hex: 0xE53935))
                    .frame(width: 20, height: 54)
                HStack(spacing: 4) {
                    Capsule().fill(Color(hex: 0x8A97A8)).frame(width: 10, height: 28)
                    Capsule().fill(Color(hex: 0x8A97A8)).frame(width: 10, height: 28)
                }
            }
            .padding(.trailing, 28)
        }
        .frame(height: 110)
        .accessibilityHidden(true)
    }
}

#Preview {
    VStack {
        CrazyButton(title: "PLAY", icon: "play.fill") {}
        IngredientTray(ingredients: [Ingredient(id: .cheese), Ingredient(id: .pineapple, isChaosBait: true)], placed: []) { _ in }
    }
    .padding()
    .background(GameTheme.factoryBlue)
}
