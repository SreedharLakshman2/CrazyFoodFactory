import SwiftUI
import UIKit

struct DeveloperInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPrivacy = false
    @State private var showSupport = false

    private var versionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground(compact: true)
                VStack(spacing: 12) {
                    HStack {
                        BackCircleButton { dismiss() }
                        Spacer()
                        Text("Developer")
                            .font(GameFont.title(metrics.type(26, cap: 36)))
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
                            VStack(spacing: 6) {
                                Text(Brand.studio)
                                    .font(GameFont.title(metrics.type(34, cap: 44)))
                                    .foregroundStyle(Brand.wordmark)
                                Text(Brand.company)
                                    .font(GameFont.headline(metrics.type(16, cap: 20)))
                                    .foregroundColor(GameTheme.navy)
                                Text("Kids games, made with care.")
                                    .font(GameFont.caption(metrics.type(13, cap: 16)))
                                    .foregroundColor(GameTheme.navy.opacity(0.62))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)

                            VStack(spacing: 0) {
                                fact("App", Brand.name)
                                fact("Studio", Brand.studio)
                                fact("Company", Brand.company)
                                fact("Developer", Brand.developer)
                                fact("Version", versionText)
                            }
                            .padding(16)
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

                            VStack(spacing: 10) {
                                CrazyButton(
                                    title: "ALL SREEO APPS",
                                    icon: "square.grid.2x2.fill",
                                    kind: .play
                                ) {
                                    UIApplication.shared.open(DeveloperCatalog.storePage)
                                }
                                Button("Privacy Policy") { showPrivacy = true }
                                    .font(GameFont.headline(metrics.type(16, cap: 20)))
                                    .foregroundColor(GameTheme.navy.opacity(0.72))
                                Button("Support") { showSupport = true }
                                    .font(GameFont.headline(metrics.type(16, cap: 20)))
                                    .foregroundColor(GameTheme.navy.opacity(0.72))
                            }
                            .factoryButtonWidth()

                            Text(Brand.copyright)
                                .font(GameFont.caption(13))
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
        .sheet(isPresented: $showPrivacy) { LegalPage(title: "Privacy Policy", bodyText: LegalCopy.privacy) }
        .sheet(isPresented: $showSupport) { LegalPage(title: "Support", bodyText: LegalCopy.support) }
        .statusBarHidden(true)
    }

    private func fact(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(GameFont.caption(13))
                .foregroundColor(GameTheme.navy.opacity(0.55))
            Spacer()
            Text(value)
                .font(GameFont.headline(16))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }
}

#Preview {
    DeveloperInfoView()
}
