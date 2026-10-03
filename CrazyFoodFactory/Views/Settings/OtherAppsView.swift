import SwiftUI
import UIKit

struct OtherAppsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            let metrics = FactoryMetrics.make(geo)
            ZStack {
                FactoryBackground(compact: true)
                VStack(spacing: 12) {
                    HStack {
                        BackCircleButton { dismiss() }
                        Spacer()
                        Text("More from sreeo")
                            .font(GameFont.title(metrics.type(24, cap: 34)))
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

                    Text("Other apps from Sai Laksha Technologies")
                        .font(GameFont.caption(metrics.type(13, cap: 17)))
                        .foregroundColor(GameTheme.navy.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(DeveloperCatalog.apps) { app in
                                Button {
                                    UIApplication.shared.open(app.storeURL)
                                } label: {
                                    HStack(spacing: 12) {
                                        Text(app.emoji)
                                            .font(.system(size: metrics.type(28, cap: 34)))
                                            .frame(width: 52, height: 52)
                                            .background(Circle().fill(Color(hex: 0xFFF4D6)))
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(app.name)
                                                .font(GameFont.headline(metrics.type(17, cap: 22)))
                                                .foregroundColor(GameTheme.navy)
                                            Text(app.blurb)
                                                .font(GameFont.caption(metrics.type(13, cap: 16)))
                                                .foregroundColor(GameTheme.navy.opacity(0.62))
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(GameTheme.navy.opacity(0.35))
                                    }
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                                            .fill(Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                }
                                .buttonStyle(PressScaleStyle(pressedScale: 0.98))
                                .accessibilityLabel(app.name)
                                .accessibilityHint("Opens in the App Store")
                            }

                            CrazyButton(
                                title: "ALL SREEO APPS",
                                icon: "square.grid.2x2.fill",
                                kind: .next
                            ) {
                                UIApplication.shared.open(DeveloperCatalog.storePage)
                            }
                            .factoryButtonWidth()
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 28)
                    }
                }
                .factoryReadableWidth()
                .padding(.top, metrics.chromeTop)
                .padding(.bottom, metrics.chromeBottom)
            }
            .factoryMetrics(metrics)
        }
        .statusBarHidden(true)
    }
}

#Preview {
    OtherAppsView()
}
