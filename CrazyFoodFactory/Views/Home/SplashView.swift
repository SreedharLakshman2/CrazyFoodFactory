import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appear = false
    @State private var finished = false

    var body: some View {
        ZStack {
            Brand.cream.ignoresSafeArea()

            VStack(spacing: 14) {
                SreeoTiles(size: 26, spacing: 6, dropIn: true, appear: appear, reduceMotion: reduceMotion)
                Text(Brand.studio)
                    .font(.system(size: 46, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.wordmark)
                    .scaleEffect(appear || reduceMotion ? 1 : 0.5)
                    .opacity(appear ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7).delay(0.35),
                        value: appear
                    )
                Text(Brand.name)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.45))
                    .opacity(appear ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .easeOut(duration: 0.45).delay(0.5),
                        value: appear
                    )
            }

            VStack(spacing: 6) {
                SreeoTiles(size: 10, spacing: 3, dropIn: false, appear: appear, reduceMotion: reduceMotion)
                Text(Brand.copyright)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            .opacity(appear ? 1 : 0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.45).delay(0.45), value: appear)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(Brand.studio). \(Brand.name). \(Brand.copyright)")
        .onAppear {
            if reduceMotion {
                appear = true
            } else {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                    appear = true
                }
            }
            let delay = reduceMotion ? 0.7 : 1.8
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: finish)
        }
    }

    private func finish() {
        guard finished == false else { return }
        finished = true
        onFinished()
    }
}

struct SreeoTiles: View {
    var size: CGFloat
    var spacing: CGFloat
    var dropIn: Bool
    var appear: Bool
    var reduceMotion: Bool

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<Brand.tiles.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: size * 0.23, style: .continuous)
                    .fill(Brand.tiles[index])
                    .frame(width: size, height: size)
                    .offset(y: dropIn && appear == false && reduceMotion == false ? -60 : 0)
                    .opacity(dropIn ? (appear ? 1 : 0) : 1)
                    .animation(
                        dropIn && reduceMotion == false
                            ? .spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.1)
                            : nil,
                        value: appear
                    )
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    SplashView(onFinished: {})
}
