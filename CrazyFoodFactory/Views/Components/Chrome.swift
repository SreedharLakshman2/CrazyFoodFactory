import SwiftUI

struct CrazyButton: View {
    var title: String
    var icon: String? = nil
    var kind: Kind = .play
    var fillsWidth: Bool = true
    var playsTap: Bool = true
    var action: () -> Void

    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.factoryMetrics) private var metrics

    enum Kind {
        case play, next, retry, home, danger
    }

    private var pad: Bool { sizeClass == .regular || metrics.pad }

    var body: some View {
        Button(action: {
            if playsTap { AudioManager.shared.tap() }
            Haptics.light()
            action()
        }) {
            HStack(spacing: pad ? 12 : 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: metrics.type(22, cap: 28), weight: .heavy))
                }
                Text(title)
                    .font(GameFont.title(metrics.type(kind == .play ? 28 : 22, cap: kind == .play ? 38 : 30)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(foreground)
            .padding(.horizontal, pad ? 34 : 28)
            .frame(maxWidth: fillsWidth ? .infinity : nil)
            .frame(height: kind == .play ? (pad ? 82 : 68) : (pad ? 70 : 60))
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

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var diameter: CGFloat { sizeClass == .regular ? 60 : 52 }

    var body: some View {
        Button {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: sizeClass == .regular ? 20 : 18, weight: .bold))
                .foregroundColor(GameTheme.navy.opacity(dimmed ? 0.35 : 1))
                .frame(width: diameter, height: diameter)
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
    @Environment(\.factoryMetrics) private var metrics

    var body: some View {
        Text(text)
            .font(GameFont.headline(metrics.type(compact ? 18 : 24, cap: compact ? 28 : 34)))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(hex: 0x16345C), Color(hex: 0x2A5A9A), Color(hex: 0xFF6A3C)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, compact ? 18 : 24)
            .padding(.vertical, compact ? (metrics.pad ? 14 : 12) : (metrics.pad ? 18 : 16))
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color(hex: 0xE8F8FF),
                                Color(hex: 0xFFF3B8),
                                Color(hex: 0xFFD8F0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: 0xFF9A3C).opacity(0.22), radius: 10, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white, Color(hex: 0xFFE56A), Color(hex: 0xFFB6E8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
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
    @Environment(\.factoryMetrics) private var metrics

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < filled ? "star.fill" : "star")
                    .font(.system(size: metrics.type(16, cap: 22), weight: .bold))
                    .foregroundColor(i < filled ? GameTheme.primaryYellow : Color.white.opacity(0.7))
            }
        }
        .padding(.horizontal, metrics.pad ? 12 : 10)
        .padding(.vertical, metrics.pad ? 9 : 7)
        .background(Capsule().fill(Color.white.opacity(0.22)))
        .accessibilityLabel("Progress \(filled) stars")
    }
}

struct FoodCard: View {
    let food: FoodType
    var wide: Bool = false
    var artSize: CGFloat = 112
    var action: () -> Void
    @Environment(\.factoryMetrics) private var metrics

    var body: some View {
        Button {
            AudioManager.shared.tap()
            Haptics.light()
            action()
        } label: {
            VStack(spacing: 10) {
                FoodIllustrationView(food: food, size: artSize)
                Text(food.displayName)
                    .font(GameFont.headline(metrics.type(wide ? 20 : 17, cap: 26)))
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
    var highlighted: Bool = false
    var action: () -> Void
    @Environment(\.factoryMetrics) private var metrics

    var body: some View {
        let art = metrics.art(compact ? 58 : 64, cap: compact ? 72 : 84)
        Button(action: action) {
            VStack(spacing: 6) {
                IngredientArt(id: ingredient.id)
                    .frame(width: art, height: art)
                    .opacity(used ? 0.45 : 1)
                Text(ingredient.displayName)
                    .font(GameFont.caption(metrics.type(13, cap: 18)))
                    .foregroundColor(GameTheme.navy)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .frame(width: art + 12)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(highlighted ? Color(hex: 0xFFE56A).opacity(0.45) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(highlighted ? Color(hex: 0xFF7A28) : Color.clear, lineWidth: 3)
            )
            .scaleEffect(highlighted ? 1.04 : 1)
            .opacity(used && !ingredient.isOptional ? 0.7 : 1)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel("\(ingredient.displayName). \(ingredient.kidFact)")
        .accessibilityAddTraits(highlighted ? .isSelected : [])
    }
}

struct IngredientTray: View {
    let ingredients: [Ingredient]
    let placed: [IngredientID]
    var focused: IngredientID? = nil
    var compact: Bool = false
    var onTap: (IngredientID) -> Void

    @State private var didHintScroll = false

    private var focusID: IngredientID? {
        focused ?? ingredients.first(where: { !placed.contains($0.id) })?.id ?? ingredients.first?.id
    }

    private var canHintMore: Bool {
        ingredients.count > 5
    }

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .trailing) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: compact ? 8 : 10) {
                            ForEach(ingredients) { item in
                                IngredientCard(
                                    ingredient: item,
                                    used: placed.contains(item.id) && !item.isOptional && !item.isChaosBait,
                                    compact: compact,
                                    highlighted: item.id == focusID
                                ) {
                                    onTap(item.id)
                                }
                                .id(item.id)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .frame(minWidth: geo.size.width, alignment: .leading)
                    }
                    .scrollClipDisabled()
                    .defaultScrollAnchor(.leading)

                    if canHintMore {
                        scrollHint
                    }
                }
                .onAppear {
                    jumpToFocus(proxy, animated: false)
                    hintThereIsMore(proxy)
                }
                .onChange(of: focusID) { _, _ in
                    jumpToFocus(proxy, animated: true)
                }
            }
        }
        .frame(height: compact ? 108 : 118)
        .accessibilityElement(children: .contain)
        .accessibilityHint(canHintMore ? "Swipe sideways for more toppings." : "")
    }

    private var scrollHint: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 22, weight: .heavy))
            .foregroundColor(GameTheme.navy.opacity(0.45))
            .padding(.trailing, 6)
            .phaseAnimator([false, true]) { content, bouncing in
                content.offset(x: bouncing ? 5 : 0)
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private func jumpToFocus(_ proxy: ScrollViewProxy, animated: Bool) {
        guard let focusID else { return }
        let jump = { proxy.scrollTo(focusID, anchor: .leading) }
        if animated {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.86), jump)
        } else {
            DispatchQueue.main.async(execute: jump)
        }
    }

    private func hintThereIsMore(_ proxy: ScrollViewProxy) {
        guard canHintMore, didHintScroll == false, let focusID else { return }
        didHintScroll = true
        guard let index = ingredients.firstIndex(where: { $0.id == focusID }),
              ingredients.indices.contains(index + 2) else { return }
        let peekID = ingredients[index + 2].id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeInOut(duration: 0.48)) {
                proxy.scrollTo(peekID, anchor: .center)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.84)) {
                    proxy.scrollTo(focusID, anchor: .leading)
                }
            }
        }
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
    @Environment(\.factoryMetrics) private var metrics

    var body: some View {
        HStack(spacing: 8) {
            FoodIllustrationView(food: food, size: metrics.art(28, cap: 40))
            Text(title)
                .font(GameFont.headline(metrics.type(16, cap: 24)))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xE8F7FF), Color(hex: 0xFFF4D6), Color(hex: 0xFFD8F0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
        .overlay(
            Capsule().stroke(
                LinearGradient(
                    colors: [Color.white, Color(hex: 0xFFE56A)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 2
            )
        )
        .shadow(color: Color(hex: 0xFF9A3C).opacity(0.18), radius: 8, y: 4)
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
        VStack(spacing: 12) {
            Text(result.message)
                .font(GameFont.title(22))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.white.opacity(0.8), radius: 0, y: 1)
            ForEach(checklist, id: \.self) { item in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: 0x49E57D), Color(hex: 0x1DB954)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .font(.system(size: 26, weight: .bold))
                    IngredientArt(id: item)
                        .frame(width: 40, height: 40)
                    Text(item.displayName)
                        .font(GameFont.headline(20))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: 0x16345C), Color(hex: 0x2A5A9A)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color(hex: 0xFFF8E0), Color(hex: 0xE8F8FF)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xE8F7FF), Color(hex: 0xFFF4D6), Color(hex: 0xFFE7F2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xFFE56A), Color(hex: 0xFFB6E8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
        .shadow(color: Color(hex: 0xFF8A3D).opacity(0.2), radius: 14, y: 8)
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
