import SwiftUI

struct FactoryBackground: View {
    var busy: Bool = true
    var compact: Bool = false

    var body: some View {
        let _ = (busy, compact)
        LinearGradient(
            colors: [
                Color(hex: 0x5CC8FF),
                Color(hex: 0x9FE4FF),
                Color(hex: 0xEAF7FF),
                Color.white
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

#Preview {
    FactoryBackground()
}
