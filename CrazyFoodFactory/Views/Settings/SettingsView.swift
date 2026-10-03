import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStateStore
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var confirmReset = false
    @State private var showPrivacy = false
    @State private var showSupport = false
    @State private var showOtherApps = false
    @State private var showDeveloper = false

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
            FactoryBackground(compact: true)
            VStack(spacing: 14) {
                HStack {
                    BackCircleButton { dismiss() }
                    Spacer()
                    Text("Settings")
                        .font(GameFont.title(metrics.type(28, cap: 38)))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: 0x16345C), Color(hex: 0x4EC3FF)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Spacer()
                    Color.clear.frame(width: 52, height: 52)
                }
                .padding(.horizontal, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        settingsCard(title: "Kitchen Sounds", icon: "speaker.wave.2.fill", tint: Color(hex: 0x4EC3FF)) {
                            VStack(spacing: 6) {
                                soundToggle(
                                    title: "Music",
                                    icon: "music.note",
                                    tint: Color(hex: 0xFF9A3C),
                                    on: store.save.musicEnabled
                                ) {
                                    store.setMusic(!store.save.musicEnabled)
                                }
                                soundToggle(
                                    title: "Sound Effects",
                                    icon: "sparkles",
                                    tint: Color(hex: 0x27D36A),
                                    on: store.save.soundEnabled
                                ) {
                                    store.setSound(!store.save.soundEnabled)
                                }
                                soundToggle(
                                    title: "Chef Voice",
                                    icon: "mouth.fill",
                                    tint: Color(hex: 0xFF5A8A),
                                    on: store.save.speechEnabled
                                ) {
                                    store.setSpeech(!store.save.speechEnabled)
                                }
                            }
                        }

                        settingsCard(title: "Play & Learn", icon: "fork.knife", tint: Color(hex: 0xFF8A3D)) {
                            VStack(spacing: 4) {
                                navRow(title: "How Kids Learn", icon: "lightbulb.fill", tint: Color(hex: 0xFFE14A)) {
                                    dismiss()
                                    router.go(.ingredientSchool)
                                }
                                navRow(title: "How To Play", icon: "hand.tap.fill", tint: Color(hex: 0xFF8A3D)) {
                                    dismiss()
                                    router.go(.howTo)
                                }
                                navRow(title: "Level Map", icon: "map.fill", tint: Color(hex: 0x4EC3FF)) {
                                    dismiss()
                                    router.go(.levelMap)
                                }
                                navRow(title: "Rewards", icon: "gift.fill", tint: Color(hex: 0xFF5A8A)) {
                                    dismiss()
                                    router.go(.rewards)
                                }
                            }
                        }

                        settingsCard(title: "Help", icon: "heart.fill", tint: Color(hex: 0xFF6B8A)) {
                            VStack(spacing: 4) {
                                navRow(title: "Privacy Policy", icon: "lock.fill", tint: Color(hex: 0x7AD4FF)) {
                                    showPrivacy = true
                                }
                                navRow(title: "Support", icon: "questionmark.circle.fill", tint: Color(hex: 0x27D36A)) {
                                    showSupport = true
                                }
                            }
                        }

                        settingsCard(title: "From sreeo", icon: "sparkles", tint: Color(hex: 0xC8B6FF)) {
                            VStack(spacing: 4) {
                                navRow(title: "Other sreeo Apps", icon: "square.grid.2x2.fill", tint: Color(hex: 0xFF9A3C)) {
                                    showOtherApps = true
                                }
                                navRow(title: "Developer Info", icon: "person.crop.rectangle.fill", tint: Color(hex: 0x4EC3FF)) {
                                    showDeveloper = true
                                }
                            }
                        }

                        Button {
                            confirmReset = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 18, weight: .heavy))
                                Text("Reset Progress")
                                    .font(GameFont.headline(20))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: 0xFF8A7A), GameTheme.dangerRed],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            .overlay(Capsule().stroke(Color.white.opacity(0.55), lineWidth: 2))
                            .shadow(color: GameTheme.dangerRed.opacity(0.28), radius: 0, y: 5)
                        }
                        .buttonStyle(PressScaleStyle())
                        .accessibilityLabel("Reset Progress")
                        .padding(.top, 4)

                        VStack(spacing: 4) {
                            Text(Brand.studio)
                                .font(GameFont.caption(13))
                            Text(Brand.copyright)
                                .font(GameFont.caption(13))
                        }
                        .foregroundColor(GameTheme.navy.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 18)
                }
            }
            .factoryReadableWidth()
            .padding(.top, metrics.chromeTop)
            .padding(.bottom, metrics.chromeBottom)
        }
        .factoryMetrics(metrics)
        }
        .alert("Reset all stars and levels?", isPresented: $confirmReset) {
            Button("Reset", role: .destructive) { store.resetProgress() }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showPrivacy) { LegalPage(title: "Privacy Policy", bodyText: LegalCopy.privacy) }
        .sheet(isPresented: $showSupport) { LegalPage(title: "Support", bodyText: LegalCopy.support) }
        .sheet(isPresented: $showOtherApps) { OtherAppsView() }
        .sheet(isPresented: $showDeveloper) { DeveloperInfoView() }
        .statusBarHidden(true)
    }

    private func settingsCard<Content: View>(
        title: String,
        icon: String,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(tint))
                Text(title)
                    .font(GameFont.headline(18))
                    .foregroundColor(GameTheme.navy)
            }
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(hex: 0xF4FBFF)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white, lineWidth: 3)
        )
        .shadow(color: Color(hex: 0x4EC3FF).opacity(0.16), radius: 12, y: 6)
    }

    private func soundToggle(title: String, icon: String, tint: Color, on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(tint))
                Text(title)
                    .font(GameFont.headline(18))
                    .foregroundColor(GameTheme.navy)
                Spacer()
                Text(on ? "ON" : "OFF")
                    .font(GameFont.title(16))
                    .foregroundColor(.white)
                    .frame(width: 72, height: 38)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: on
                                        ? [Color(hex: 0x49E57D), Color(hex: 0x1DB954)]
                                        : [Color(hex: 0xB0BEC5), Color(hex: 0x90A4AE)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleStyle(pressedScale: 0.98))
        .accessibilityLabel("\(title) \(on ? "on" : "off")")
    }

    private func navRow(title: String, icon: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(tint))
                Text(title)
                    .font(GameFont.headline(18))
                    .foregroundColor(GameTheme.navy)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(GameTheme.navy.opacity(0.35))
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleStyle(pressedScale: 0.98))
        .accessibilityLabel(title)
    }
}

struct LegalPage: View {
    let title: String
    let bodyText: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(bodyText)
                    .font(GameFont.body(16))
                    .foregroundColor(GameTheme.navy)
                    .padding()
            }
            .background(GameTheme.factoryLightBlue.ignoresSafeArea())
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

enum LegalCopy {
    static let privacy = """
    Kido Chef is made by Sai Laksha Technologies for kids.

    The game works completely offline. Progress and sound settings stay on this device. We do not collect personal information, location, or contacts.

    You can reset progress any time from Settings.
    """

    static let support = """
    Need a hand in the kitchen?

    Open Settings to turn music or sounds on and off, or reset your level progress.

    Privacy Policy and Support links live with Sai Laksha Technologies on the Kido Chef website.
    """
}

#Preview {
    SettingsView()
        .environmentObject(GameStateStore.preview)
        .environmentObject(AppRouter())
}
