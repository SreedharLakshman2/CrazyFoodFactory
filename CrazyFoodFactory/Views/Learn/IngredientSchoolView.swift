import SwiftUI

struct IngredientSchoolView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var selected: IngredientID?
    @State private var groupFilter: IngredientGroup?

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            let pad = FactoryLayout.isRegular(geo.size)
            ZStack(alignment: .bottom) {
                FactoryBackground(compact: true)
                VStack(spacing: 0) {
                    header
                    SpeechBubble(
                        text: "Tap a food. Learn what it is and how chefs use it!",
                        compact: true
                    )
                    .padding(.horizontal, pad ? 40 : 28)
                    .padding(.top, 8)
                    .padding(.bottom, 10)

                    groupChips
                        .padding(.bottom, 6)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(visibleGroups) { group in
                                section(group, compact: short, columns: pad ? 4 : 3)
                            }
                        }
                        .padding(.horizontal, pad ? 24 : 18)
                        .padding(.bottom, 28)
                    }
                    .scrollDisabled(selected != nil)
                }
                .factoryReadableWidth()

                if let selected {
                    IngredientLessonSheet(
                        id: selected,
                        maxHeight: geo.size.height * (pad ? 0.88 : 0.78)
                    ) {
                        closeLesson()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
            }
            .animation(.spring(response: 0.42, dampingFraction: 0.86), value: selected)
        }
        .statusBarHidden(true)
        .onAppear {
            let args = ProcessInfo.processInfo.arguments
            if let index = args.firstIndex(of: "-food"),
               args.indices.contains(index + 1),
               let id = IngredientID(rawValue: args[index + 1]) {
                selected = id
            }
        }
        .onDisappear {
            AudioManager.shared.stopSpeech()
        }
    }

    private func closeLesson() {
        AudioManager.shared.stopSpeech()
        selected = nil
    }

    private var header: some View {
        HStack {
            BackCircleButton {
                closeLesson()
                router.go(.home)
            }
            Spacer()
            Text("Ingredient School")
                .font(GameFont.title(sizeClass == .regular ? 32 : 26))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Spacer()
            Color.clear.frame(width: 60, height: 60)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }

    private var groupChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("All", tint: GameTheme.factoryBlue, selected: groupFilter == nil) {
                    groupFilter = nil
                }
                ForEach(IngredientGroup.allCases) { group in
                    chip(group.title, tint: group.tint, selected: groupFilter == group) {
                        groupFilter = groupFilter == group ? nil : group
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private func chip(_ title: String, tint: Color, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(GameFont.caption(13))
                .foregroundColor(selected ? .white : GameTheme.navy)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(selected ? tint : Color.white.opacity(0.92))
                )
                .overlay(Capsule().stroke(Color.white, lineWidth: 2))
        }
        .buttonStyle(PressScaleStyle())
        .disabled(self.selected != nil)
    }

    private var visibleGroups: [IngredientGroup] {
        if let groupFilter { return [groupFilter] }
        return IngredientGroup.allCases.filter { group in
            !IngredientID.schoolRoster.filter { $0.schoolGroup == group }.isEmpty
        }
    }

    private func section(_ group: IngredientGroup, compact: Bool, columns: Int = 3) -> some View {
        let items = IngredientID.schoolRoster.filter { $0.schoolGroup == group }
        let grid = Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
        return VStack(alignment: .leading, spacing: 10) {
            Text(group.title)
                .font(GameFont.headline(18))
                .foregroundColor(GameTheme.navy)
                .padding(.leading, 4)
            LazyVGrid(columns: grid, spacing: 10) {
                ForEach(items) { id in
                    IngredientCard(
                        ingredient: Ingredient(id: id),
                        compact: compact
                    ) {
                        AudioManager.shared.tap()
                        Haptics.light()
                        selected = id
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, group.tint.opacity(0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
    }
}

struct IngredientLessonSheet: View {
    let id: IngredientID
    var maxHeight: CGFloat
    var onClose: () -> Void

    @ObservedObject private var audio = AudioManager.shared
    @State private var dragOffset: CGFloat = 0

    private var dishes: [FoodType] {
        Array(FoodCatalog.foods(using: id).prefix(6))
    }

    var body: some View {
        GeometryReader { geo in
            let metrics = LessonMetrics(size: geo.size)
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.38)
                    .ignoresSafeArea()
                    .onTapGesture { onClose() }
                    .accessibilityLabel("Close lesson")

                ViewThatFits(in: .vertical) {
                    sheetPanel(metrics: metrics, scrolling: false)
                    sheetPanel(metrics: metrics, scrolling: true)
                        .frame(maxHeight: maxHeight)
                }
                .frame(width: metrics.panelWidth)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: metrics.pad ? 44 : 36,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: metrics.pad ? 44 : 36,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color(hex: 0xE8F7FF),
                                Color(hex: 0xFFF8E8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color(hex: 0x16345C).opacity(0.22), radius: 18, y: -6)
                )
                .overlay(alignment: .top) {
                    UnevenRoundedRectangle(
                        topLeadingRadius: metrics.pad ? 44 : 36,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: metrics.pad ? 44 : 36,
                        style: .continuous
                    )
                    .stroke(Color.white, lineWidth: 3)
                }
                .offset(y: dragOffset)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .accessibilityAddTraits(.isModal)
        .onDisappear {
            AudioManager.shared.stopSpeech()
        }
    }

    @ViewBuilder
    private func sheetPanel(metrics: LessonMetrics, scrolling: Bool) -> some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(hex: 0x16345C).opacity(0.22))
                .frame(width: metrics.pad ? 56 : 44, height: metrics.pad ? 7 : 5)
                .padding(.top, metrics.pad ? 14 : 10)
                .padding(.bottom, metrics.pad ? 12 : 8)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(dismissDrag)

            if scrolling {
                ScrollView(showsIndicators: false) {
                    lessonBody(metrics: metrics)
                }
            } else {
                lessonBody(metrics: metrics)
            }

            CrazyButton(
                title: hearTitle,
                icon: hearIcon,
                kind: audio.isSpeaking && !audio.isPaused ? .home : .play
            ) {
                audio.toggleSpeech(id.schoolLesson)
            }
            .factoryButtonWidth()
            .padding(.horizontal, metrics.pad ? 40 : 28)
            .padding(.top, 10)

            Button("Close") { onClose() }
                .font(GameFont.headline(metrics.close))
                .foregroundColor(GameTheme.navy.opacity(0.7))
                .padding(.top, 10)
                .padding(.bottom, metrics.pad ? 24 : 18)
        }
    }

    private func lessonBody(metrics: LessonMetrics) -> some View {
        VStack(spacing: metrics.stack) {
            IngredientArt(id: id)
                .frame(width: metrics.art, height: metrics.art)
                .padding(metrics.artPad)
                .background(
                    Circle().fill(
                        LinearGradient(
                            colors: [Color.white, id.trayColor.opacity(0.45)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                )
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(color: id.trayColor.opacity(0.35), radius: 10, y: 6)

            Text(id.displayName)
                .font(GameFont.title(metrics.title))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(1)

            lessonBlock(
                title: "What it is",
                text: id.kidFact,
                metrics: metrics,
                tint: Color(hex: 0xE8F8FF)
            )
            lessonBlock(
                title: "How chefs cook it",
                text: id.cookingUse,
                metrics: metrics,
                tint: Color(hex: 0xFFF4D6)
            )

            if !dishes.isEmpty {
                VStack(spacing: metrics.pad ? 12 : 8) {
                    Text("Kids cook it in")
                        .font(GameFont.headline(metrics.caption))
                        .foregroundColor(GameTheme.navy.opacity(0.78))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: metrics.pad ? 16 : 12) {
                            ForEach(dishes) { food in
                                VStack(spacing: 8) {
                                    FoodIllustrationView(food: food, size: metrics.dishArt)
                                    Text(food.displayName)
                                        .font(GameFont.headline(metrics.dish))
                                        .foregroundColor(GameTheme.navy)
                                        .lineLimit(2)
                                        .minimumScaleFactor(1)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: metrics.dishArt + 28)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
        }
        .padding(.horizontal, metrics.gutter)
        .padding(.bottom, 10)
    }

    private func lessonBlock(title: String, text: String, metrics: LessonMetrics, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: metrics.pad ? 10 : 6) {
            Text(title)
                .font(GameFont.caption(metrics.caption))
                .foregroundColor(Color(hex: 0xFF7A28))
            Text(text)
                .font(GameFont.body(metrics.fact))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, metrics.pad ? 22 : 16)
        .padding(.vertical, metrics.pad ? 18 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: metrics.pad ? 24 : 18, style: .continuous)
                .fill(tint)
        )
        .overlay(
            RoundedRectangle(cornerRadius: metrics.pad ? 24 : 18, style: .continuous)
                .stroke(Color.white, lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(text)")
    }

    private var hearTitle: String {
        if audio.isPaused { return "RESUME" }
        if audio.isSpeaking { return "PAUSE" }
        return "HEAR IT"
    }

    private var hearIcon: String {
        if audio.isPaused { return "play.fill" }
        if audio.isSpeaking { return "pause.fill" }
        return "speaker.wave.2.fill"
    }

    private var dismissDrag: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                dragOffset = max(0, value.translation.height)
            }
            .onEnded { value in
                if value.translation.height > 110 || value.predictedEndTranslation.height > 180 {
                    onClose()
                } else {
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

private struct LessonMetrics {
    let pad: Bool
    let panelWidth: CGFloat
    let art: CGFloat
    let artPad: CGFloat
    let title: CGFloat
    let fact: CGFloat
    let caption: CGFloat
    let dish: CGFloat
    let dishArt: CGFloat
    let close: CGFloat
    let gutter: CGFloat
    let stack: CGFloat

    init(size: CGSize) {
        pad = FactoryLayout.isRegular(size)
        let scale = FactoryLayout.scale(in: size)
        let bump = pad ? max(scale / 1.28, 1.15) : 1
        panelWidth = pad ? min(size.width - 56, 860) : size.width
        art = (pad ? 168 : 108) * (pad ? min(bump, 1.22) : 1)
        artPad = pad ? 22 : 16
        title = (pad ? 44 : 30) * (pad ? min(bump, 1.18) : 1)
        fact = (pad ? 26 : 17) * (pad ? min(bump, 1.18) : 1)
        caption = (pad ? 18 : 13) * (pad ? min(bump, 1.15) : 1)
        dish = (pad ? 17 : 12) * (pad ? min(bump, 1.15) : 1)
        dishArt = (pad ? 76 : 56) * (pad ? min(bump, 1.18) : 1)
        close = pad ? 22 : 16
        gutter = pad ? 32 : 22
        stack = pad ? 20 : 12
    }
}

#Preview {
    IngredientSchoolView()
        .environmentObject(AppRouter())
}
