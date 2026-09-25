import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStateStore
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var confirmReset = false
    @State private var showPrivacy = false
    @State private var showSupport = false

    var body: some View {
        ZStack {
            FactoryBackground(compact: true)
            VStack(spacing: 18) {
                HStack {
                    BackCircleButton { dismiss() }
                    Spacer()
                    Text("Settings")
                        .font(GameFont.title(28))
                        .foregroundColor(GameTheme.navy)
                    Spacer()
                    Color.clear.frame(width: 52, height: 52)
                }
                .padding(.horizontal, 16)

                VStack(spacing: 14) {
                    toggleRow(title: "Music", on: store.save.musicEnabled) {
                        store.setMusic(!store.save.musicEnabled)
                    }
                    toggleRow(title: "Sound Effects", on: store.save.soundEnabled) {
                        store.setSound(!store.save.soundEnabled)
                    }
                    Button {
                        confirmReset = true
                    } label: {
                        Text("Reset Progress")
                            .font(GameFont.headline(20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(LinearGradient(colors: [Color(hex: 0xFF8A7A), GameTheme.dangerRed], startPoint: .top, endPoint: .bottom))
                            )
                    }
                    .buttonStyle(PressScaleStyle())
                    .accessibilityLabel("Reset Progress")

                    Button("How Kids Learn") {
                        dismiss()
                        router.go(.howTo)
                    }
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy)
                    Button("Level Map") {
                        dismiss()
                        router.go(.levelMap)
                    }
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy)
                    Button("Privacy Policy") { showPrivacy = true }
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                    Button("Support") { showSupport = true }
                        .font(GameFont.headline(16))
                        .foregroundColor(GameTheme.navy)
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.white.opacity(0.92)))
                .padding(.horizontal, 18)

                Text(Brand.copyright)
                    .font(GameFont.caption(13))
                    .foregroundColor(GameTheme.navy.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer()
            }
            .factoryReadableWidth()
            .padding(.top, 10)
        }
        .alert("Reset all stars and levels?", isPresented: $confirmReset) {
            Button("Reset", role: .destructive) { store.resetProgress() }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showPrivacy) { LegalPage(title: "Privacy Policy", bodyText: LegalCopy.privacy) }
        .sheet(isPresented: $showSupport) { LegalPage(title: "Support", bodyText: LegalCopy.support) }
    }

    private func toggleRow(title: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(GameFont.headline(20))
                    .foregroundColor(GameTheme.navy)
                Spacer()
                Text(on ? "ON" : "OFF")
                    .font(GameFont.title(18))
                    .foregroundColor(.white)
                    .frame(width: 84, height: 44)
                    .background(Capsule().fill(on ? GameTheme.playGreen : Color(hex: 0x90A4AE)))
            }
            .padding(.horizontal, 8)
            .frame(height: 64)
        }
        .buttonStyle(PressScaleStyle(pressedScale: 0.98))
        .accessibilityLabel("\(title) \(on ? "on" : "off")")
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
    Crazy Food Factory is made by Sai Laksha Technologies for kids.

    The game works completely offline. Progress and sound settings stay on this device. We do not collect personal information, location, or contacts.

    You can reset progress any time from Settings.
    """

    static let support = """
    Need a hand in the factory?

    Open Settings to turn music or sounds on and off, or reset your level progress.

    Visit the Support page from the app website listed with Sai Laksha Technologies.
    """
}

#Preview {
    SettingsView()
        .environmentObject(GameStateStore.preview)
        .environmentObject(AppRouter())
}
