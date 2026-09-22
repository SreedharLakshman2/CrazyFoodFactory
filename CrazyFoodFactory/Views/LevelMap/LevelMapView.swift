import SwiftUI

struct LevelMapView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore

    var body: some View {
        GeometryReader { geo in
            ZStack {
                FactoryBackground()

                VStack(spacing: 0) {
                    header
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            path(in: geo.size)
                            nodes(in: geo.size)
                        }
                        .frame(height: max(640, geo.size.height * 0.92))
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .statusBarHidden(true)
    }

    private var header: some View {
        HStack {
            BackCircleButton { router.go(.home) }
            Spacer()
            Text("FOOD\nFACTORY")
                .font(GameFont.headline(14))
                .foregroundColor(GameTheme.navy)
                .multilineTextAlignment(.center)
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(GameTheme.primaryYellow)
                Text("\(store.save.totalStars)/\(LevelCatalog.maxStars)")
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.white))
            SettingsButton { router.showSettings = true }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
    }

    private func path(in size: CGSize) -> some View {
        Path { p in
            let pts = nodePoints(in: size)
            guard let first = pts.first else { return }
            p.move(to: first)
            for pt in pts.dropFirst() {
                p.addLine(to: pt)
            }
        }
        .stroke(Color.white.opacity(0.85), style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [10, 12]))
        .allowsHitTesting(false)
    }

    private func nodes(in size: CGSize) -> some View {
        let points = nodePoints(in: size)
        return ZStack {
            ForEach(Array(LevelCatalog.all.enumerated()), id: \.element.id) { index, level in
                let point = points.indices.contains(index) ? points[index] : CGPoint(x: size.width / 2, y: 80)
                LevelNode(
                    level: level,
                    unlocked: store.save.unlockedLevel >= level.id,
                    completed: store.save.stars(for: level.id) > 0,
                    current: store.save.currentLevel == level.id,
                    stars: store.save.stars(for: level.id)
                ) {
                    store.startLevel(level.id)
                    router.go(.foodSelection)
                }
                .position(point)
            }
        }
    }

    private func nodePoints(in size: CGSize) -> [CGPoint] {
        let w = size.width
        let xs: [CGFloat] = [0.28, 0.70, 0.32, 0.74, 0.30, 0.68, 0.34, 0.72, 0.30, 0.66]
        return (0..<LevelCatalog.levelCount).map { i in
            CGPoint(x: w * xs[i], y: 70 + CGFloat(i) * 62)
        }
    }
}

#Preview {
    LevelMapView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
