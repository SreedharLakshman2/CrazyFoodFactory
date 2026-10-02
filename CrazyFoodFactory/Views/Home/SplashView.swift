import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appear = false
    @State private var finished = false

    var body: some View {
        GeometryReader { geo in
            let s = FactoryLayout.splashScale(in: geo.size)
            ZStack {
                Brand.cream.ignoresSafeArea()

                VStack(spacing: 14 * s) {
                    SreeoTiles(
                        size: 26 * s,
                        spacing: 6 * s,
                        dropIn: true,
                        appear: appear,
                        reduceMotion: reduceMotion
                    )
                    Text(Brand.studio)
                        .font(.system(size: 46 * s, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.wordmark)
                        .scaleEffect(appear || reduceMotion ? 1 : 0.92)
                        .opacity(appear || reduceMotion ? 1 : 0.35)
                    Text(Brand.name)
                        .font(.system(size: 18 * s, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.45))
                        .opacity(appear || reduceMotion ? 1 : 0.35)
                }

                VStack(spacing: 6 * s) {
                    SreeoTiles(
                        size: 10 * s,
                        spacing: 3 * s,
                        dropIn: false,
                        appear: true,
                        reduceMotion: reduceMotion
                    )
                    Text(Brand.copyright)
                        .font(.system(size: 13 * s, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.5))
                }
                .padding(.bottom, max(40, geo.safeAreaInsets.bottom + 24))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
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
            let delay = reduceMotion ? 0.8 : 2.0
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
                    .offset(y: dropIn && appear == false && reduceMotion == false ? -28 : 0)
                    .opacity(dropIn && appear == false && reduceMotion == false ? 0.4 : 1)
                    .animation(
                        dropIn && reduceMotion == false
                            ? .spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.08)
                            : nil,
                        value: appear
                    )
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview("iPhone") {
    SplashView(onFinished: {})
}

#Preview("iPad") {
    SplashView(onFinished: {})
}
