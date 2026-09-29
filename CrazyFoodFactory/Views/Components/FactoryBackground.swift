import SwiftUI

struct FactoryBackground: View {
    var busy: Bool = true
    var compact: Bool = false
    var celebrate: Bool = false

    var body: some View {
        let _ = (busy, compact)
        LinearGradient(
            colors: celebrate
                ? [
                    Color(hex: 0x4EC3FF),
                    Color(hex: 0x9FE4FF),
                    Color(hex: 0xFFE56A).opacity(0.55),
                    Color(hex: 0xFFD0F0).opacity(0.9)
                ]
                : [
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
