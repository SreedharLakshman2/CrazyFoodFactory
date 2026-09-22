import SwiftUI

struct PauseOverlay: View {
    var onResume: () -> Void
    var onHome: () -> Void
    var onSettings: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Paused")
                    .font(GameFont.title(32))
                    .foregroundColor(GameTheme.navy)
                CrazyButton(title: "Resume", icon: "play.fill", kind: .play, action: onResume)
                CrazyButton(title: "Home", icon: "house.fill", kind: .home, action: onHome)
                CrazyButton(title: "Settings", icon: "gearshape.fill", kind: .retry, action: onSettings)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white)
            )
            .frame(maxWidth: FactoryLayout.overlayMaxWidth)
            .padding(28)
            .softCardShadow()
        }
        .accessibilityAddTraits(.isModal)
    }
}
