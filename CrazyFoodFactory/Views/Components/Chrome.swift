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
            .font(GameFont.headline(compact ? 16 : 18))
            .foregroundColor(GameTheme.navy)
            .multilineTextAlignment(.center)
            .padding(.horizontal, compact ? 14 : 18)
            .padding(.vertical, compact ? 10 : 14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            )
            .overlay(alignment: .bottomLeading) {
                BubbleTail()
                    .fill(Color.white)
                    .frame(width: 18, height: 14)
                    .offset(x: 22, y: 8)
            }
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
    var action: () -> Void

    var body: some View {
        Button {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        } label: {
            VStack(spacing: 8) {
                FoodIllustrationView(food: food, size: wide ? 86 : 78)
                Text(food.displayName)
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, wide ? 14 : 16)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(colors: [food.cardColor, food.cardColor.opacity(0.86)], startPoint: .top, endPoint: .bottom)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.85), lineWidth: 3)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 6)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(food.displayName)
    }
}

struct IngredientCard: View {
    let ingredient: Ingredient
    var used: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [ingredient.trayColor, ingredient.trayColor.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(color: Color.black.opacity(0.12), radius: 5, y: 3)
                IngredientArt(id: ingredient.id)
                    .padding(10)
                if used {
                    Circle().fill(Color.white.opacity(0.35))
                }
            }
            .frame(width: 62, height: 62)
            .opacity(used && !ingredient.isOptional ? 0.55 : 1)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(ingredient.displayName)
    }
}

struct IngredientTray: View {
    let ingredients: [Ingredient]
    let placed: [IngredientID]
    var onTap: (IngredientID) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ingredients) { item in
                    IngredientCard(
                        ingredient: item,
                        used: placed.contains(item.id) && !item.isOptional && !item.isChaosBait
                    ) {
                        onTap(item.id)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(
            Capsule()
                .fill(Color.white.opacity(0.22))
                .padding(.horizontal, 8)
        )
        .accessibilityElement(children: .contain)
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
        .background(Capsule().fill(Color.white))
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
                        .frame(width: 72, height: 72)
                        .overlay(Circle().stroke(unlocked ? level.nodeFood.accent : Color.white.opacity(0.4), lineWidth: 4))
                        .shadow(color: Color.black.opacity(unlocked ? 0.12 : 0.05), radius: 6, y: 4)
                    if unlocked {
                        FoodIllustrationView(food: level.nodeFood, size: 42)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.9))
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
                .fill(Color.white)
        )
        .softCardShadow()
    }

    private var checklist: [IngredientID] {
        let fallback = result.placed.filter { $0 != .dough && $0 != .donutBase }
        return Array((fallback.isEmpty ? result.placed : fallback).prefix(4))
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
