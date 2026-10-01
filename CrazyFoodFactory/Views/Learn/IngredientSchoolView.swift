import SwiftUI

struct IngredientSchoolView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selected: IngredientID?
    @State private var groupFilter: IngredientGroup?

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack(alignment: .bottom) {
                FactoryBackground(compact: true)
                VStack(spacing: 0) {
                    header
                    SpeechBubble(
                        text: "Tap a food. Learn what it is and how chefs use it!",
                        compact: true
                    )
                    .padding(.horizontal, 28)
                    .padding(.top, 8)
                    .padding(.bottom, 10)

                    groupChips
                        .padding(.bottom, 6)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(visibleGroups) { group in
                                section(group, compact: short)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 28)
                    }
                    .scrollDisabled(selected != nil)
                }
                .factoryReadableWidth()

                if let selected {
                    IngredientLessonSheet(
                        id: selected,
                        maxHeight: min(geo.size.height * 0.82, 720)
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
                .font(GameFont.title(26))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Spacer()
            Color.clear.frame(width: 52, height: 52)
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

    private func section(_ group: IngredientGroup, compact: Bool) -> some View {
        let items = IngredientID.schoolRoster.filter { $0.schoolGroup == group }
        return VStack(alignment: .leading, spacing: 10) {
            Text(group.title)
                .font(GameFont.headline(18))
                .foregroundColor(GameTheme.navy)
                .padding(.leading, 4)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
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
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.38)
                .ignoresSafeArea()
                .onTapGesture { onClose() }
                .accessibilityLabel("Close lesson")

            VStack(spacing: 0) {
                sheetChrome

                if maxHeight < 560 {
                    ScrollView(showsIndicators: false) {
                        lessonStack(flexible: false)
                    }
                } else {
                    lessonStack(flexible: true)
                        .frame(maxHeight: .infinity)
                }

                actionButtons
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: maxHeight)
            .background(sheetBackground)
            .overlay(alignment: .top) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 36,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 36,
                    style: .continuous
                )
                .stroke(Color.white, lineWidth: 3)
            }
            .offset(y: dragOffset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .accessibilityAddTraits(.isModal)
        .onDisappear {
            AudioManager.shared.stopSpeech()
        }
    }

    private var sheetChrome: some View {
        HStack {
            Color.clear.frame(width: 52, height: 52)
            Spacer()
            Capsule()
                .fill(Color(hex: 0x16345C).opacity(0.22))
                .frame(width: 44, height: 5)
            Spacer()
            CircleIconButton(systemName: "xmark", accessibility: "Close") {
                onClose()
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .contentShape(Rectangle())
        .gesture(dismissDrag)
    }

    @ViewBuilder
    private func lessonStack(flexible: Bool) -> some View {
        VStack(spacing: 0) {
            if flexible { Spacer(minLength: 8) }
            IngredientArt(id: id)
                .frame(width: 148, height: 148)
                .padding(18)
                .background(
                    Circle().fill(
                        LinearGradient(
                            colors: [Color.white, id.trayColor.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                )
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(color: id.trayColor.opacity(0.35), radius: 12, y: 8)

            if flexible { Spacer(minLength: 10) } else { Color.clear.frame(height: 14) }

            Text(id.displayName)
                .font(GameFont.title(34))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            VStack(spacing: 8) {
                Text(id.kidFact)
                    .font(GameFont.body(18))
                    .foregroundColor(GameTheme.navy)
                    .multilineTextAlignment(.center)
                Text(id.cookingUse)
                    .font(GameFont.headline(17))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.86))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding(.top, 12)

            if flexible { Spacer(minLength: 12) } else { Color.clear.frame(height: 16) }

            if !dishes.isEmpty {
                dishesCard
            }

            if flexible { Spacer(minLength: 16) } else { Color.clear.frame(height: 8) }
        }
        .padding(.horizontal, 22)
    }

    private var dishesCard: some View {
        VStack(spacing: 12) {
            Text("Kids cook it in")
                .font(GameFont.caption(14))
                .foregroundColor(GameTheme.navy.opacity(0.7))
            if dishes.count <= 3 {
                HStack(spacing: 12) {
                    ForEach(dishes) { food in
                        dishChip(food)
                            .frame(maxWidth: .infinity)
                    }
                }
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(dishes) { food in
                        dishChip(food)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white, lineWidth: 2)
        )
    }

    private func dishChip(_ food: FoodType) -> some View {
        VStack(spacing: 8) {
            FoodIllustrationView(food: food, size: 76)
            Text(food.displayName)
                .font(GameFont.caption(13))
                .foregroundColor(GameTheme.navy)
                .lineLimit(1)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(food.cardColor.opacity(0.55))
        )
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            CrazyButton(
                title: hearTitle,
                icon: hearIcon
            ) {
                audio.toggleSpeech(id.schoolLesson)
            }
            CrazyButton(title: "CLOSE", icon: "xmark", kind: .home, action: onClose)
        }
        .factoryButtonWidth()
        .padding(.horizontal, 28)
        .padding(.top, 8)
        .padding(.bottom, 18)
    }

    private var sheetBackground: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 36,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 36,
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

#Preview {
    IngredientSchoolView()
        .environmentObject(AppRouter())
}
