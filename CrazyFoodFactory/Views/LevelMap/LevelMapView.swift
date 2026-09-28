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
                        let mapSize = CGSize(
                            width: FactoryLayout.contentWidth(in: geo.size),
                            height: max(1180, geo.size.height * 1.15)
                        )
                        ZStack {
                            path(in: mapSize)
                            nodes(in: mapSize)
                            VStack {
                                Spacer()
                                Text("FOOD\nFACTORY")
                                    .font(GameFont.headline(16))
                                    .foregroundColor(GameTheme.navy.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 18)
                            }
                        }
                        .frame(width: mapSize.width, height: mapSize.height)
                    }
                    .factoryReadableWidth()
                }
            }
        }
        .statusBarHidden(true)
    }

    private var header: some View {
        HStack {
            BackCircleButton { router.go(.home) }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(GameTheme.primaryYellow)
                Text("\(store.save.totalStars)/\(LevelCatalog.maxStars)")
                    .font(GameFont.headline(16))
                    .foregroundColor(GameTheme.navy)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Capsule().fill(Color.white))
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .factoryReadableWidth()
    }

    private func path(in size: CGSize) -> some View {
        let pts = nodePoints(in: size)
        return Path { p in
            guard let first = pts.first else { return }
            p.move(to: first)
            for index in 1..<pts.count {
                let previous = pts[index - 1]
                let current = pts[index]
                let mid = CGPoint(x: (previous.x + current.x) / 2, y: (previous.y + current.y) / 2)
                let sway: CGFloat = index.isMultiple(of: 2) ? 36 : -36
                p.addQuadCurve(to: current, control: CGPoint(x: mid.x + sway, y: mid.y))
            }
        }
        .stroke(Color.white.opacity(0.92), style: StrokeStyle(lineWidth: 10, lineCap: .round, dash: [14, 14]))
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
        let width = size.width
        return (0..<LevelCatalog.levelCount).map { index in
            CGPoint(
                x: width * (index.isMultiple(of: 2) ? 0.30 : 0.70),
                y: 78 + CGFloat(index) * 108
            )
        }
    }
}

#Preview {
    LevelMapView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
