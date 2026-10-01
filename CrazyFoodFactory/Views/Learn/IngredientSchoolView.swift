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
                        maxHeight: min(geo.size.height * 0.78, 640)
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
                Capsule()
                    .fill(Color(hex: 0x16345C).opacity(0.22))
                    .frame(width: 44, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .gesture(dismissDrag)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        IngredientArt(id: id)
                            .frame(width: 108, height: 108)
                            .padding(16)
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
                            .font(GameFont.title(30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: 0x16345C), Color(hex: 0xFF7A28)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text(id.kidFact)
                            .font(GameFont.body(17))
                            .foregroundColor(GameTheme.navy)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)

                        Text(id.cookingUse)
                            .font(GameFont.headline(16))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: 0xFF8A3D), Color(hex: 0xFF5A8A)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)

                        if !dishes.isEmpty {
                            VStack(spacing: 8) {
                                Text("Kids cook it in")
                                    .font(GameFont.caption(13))
                                    .foregroundColor(GameTheme.navy.opacity(0.7))
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(dishes) { food in
                                            VStack(spacing: 6) {
                                                FoodIllustrationView(food: food, size: 56)
                                                Text(food.displayName)
                                                    .font(GameFont.caption(12))
                                                    .foregroundColor(GameTheme.navy)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 78)
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 8)
                }

                CrazyButton(
                    title: hearTitle,
                    icon: hearIcon,
                    kind: audio.isSpeaking && !audio.isPaused ? .home : .play
                ) {
                    audio.toggleSpeech(id.schoolLesson)
                }
                .factoryButtonWidth()
                .padding(.horizontal, 28)
                .padding(.top, 8)

                Button("Close") { onClose() }
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy.opacity(0.7))
                    .padding(.top, 8)
                    .padding(.bottom, 18)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: maxHeight)
            .background(
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
            )
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
