import SwiftUI

struct IngredientSchoolView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selected: IngredientID?
    @State private var groupFilter: IngredientGroup?

    var body: some View {
        GeometryReader { geo in
            let short = geo.size.height < 720
            ZStack {
                FactoryBackground(compact: true)
                VStack(spacing: 0) {
                    header
                    SpeechBubble(
                        text: selected == nil
                            ? "Tap a food. Learn what it is and how chefs use it!"
                            : (selected?.schoolLesson ?? ""),
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
                }
                .factoryReadableWidth()
            }
        }
        .statusBarHidden(true)
        .sheet(item: $selected) { item in
            IngredientLessonSheet(id: item)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack {
            BackCircleButton { router.go(.home) }
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
                        selected = id
                        AudioManager.shared.speak(id.schoolLesson)
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
    @Environment(\.dismiss) private var dismiss

    private var dishes: [FoodType] {
        Array(FoodCatalog.foods(using: id).prefix(6))
    }

    var body: some View {
        ZStack {
            FactoryBackground(compact: true)
            VStack(spacing: 14) {
                Capsule()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 44, height: 5)
                    .padding(.top, 10)

                IngredientArt(id: id)
                    .frame(width: 120, height: 120)
                    .padding(18)
                    .background(
                        Circle().fill(
                            LinearGradient(
                                colors: [Color.white, id.trayColor.opacity(0.45)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    )

                Text(id.displayName)
                    .font(GameFont.title(32))
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
                    .padding(.horizontal, 24)

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
                    .padding(.horizontal, 24)

                if !dishes.isEmpty {
                    VStack(spacing: 8) {
                        Text("Kids cook it in")
                            .font(GameFont.caption(13))
                            .foregroundColor(GameTheme.navy.opacity(0.7))
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(dishes) { food in
                                    VStack(spacing: 6) {
                                        FoodIllustrationView(food: food, size: 64)
                                        Text(food.displayName)
                                            .font(GameFont.caption(12))
                                            .foregroundColor(GameTheme.navy)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 84)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }

                CrazyButton(title: "HEAR IT", icon: "speaker.wave.2.fill") {
                    AudioManager.shared.speak(id.schoolLesson)
                }
                .factoryButtonWidth()
                .padding(.horizontal, 32)

                Button("Close") { dismiss() }
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy.opacity(0.7))
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            AudioManager.shared.speak(id.schoolLesson)
        }
    }
}

#Preview {
    IngredientSchoolView()
        .environmentObject(AppRouter())
}
