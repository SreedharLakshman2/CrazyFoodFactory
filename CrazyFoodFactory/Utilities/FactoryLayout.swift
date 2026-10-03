import SwiftUI

enum FactoryLayout {
    static let phoneMaxWidth: CGFloat = 430
    static let padMaxWidth: CGFloat = 920
    static let landingMaxWidth: CGFloat = 1020
    static let buttonMaxWidth: CGFloat = 560
    static let overlayMaxWidth: CGFloat = 640

    static func isRegular(_ size: CGSize) -> Bool {
        min(size.width, size.height) >= 600 || max(size.width, size.height) >= 1000
    }

    static func contentWidth(in size: CGSize) -> CGFloat {
        if isRegular(size) {
            return min(size.width - 48, padMaxWidth)
        }
        return min(size.width, phoneMaxWidth)
    }

    static func landingWidth(in size: CGSize) -> CGFloat {
        if isRegular(size) {
            return min(size.width - 48, landingMaxWidth)
        }
        return min(size.width, phoneMaxWidth)
    }

    /// 1.0 on a standard iPhone, grows on iPad, stays readable on small phones.
    static func scale(in size: CGSize) -> CGFloat {
        let byWidth = size.width / 393
        let byHeight = size.height / 852
        let raw = min(byWidth, byHeight)
        let boosted = raw * (isRegular(size) ? 1.06 : 1)
        return min(1.58, max(0.90, boosted))
    }

    /// Splash ident can grow with width — it is a centered mark, not a packed layout.
    static func splashScale(in size: CGSize) -> CGFloat {
        let layout = scale(in: size)
        let byWidth = min(2.05, size.width / 520)
        return max(layout, byWidth)
    }
}

struct FactoryMetrics: Equatable {
    let size: CGSize
    let safeTop: CGFloat
    let safeBottom: CGFloat
    let safeLeading: CGFloat
    let safeTrailing: CGFloat

    var pad: Bool { FactoryLayout.isRegular(size) }
    var landscape: Bool { size.width > size.height + 40 }
    var compact: Bool { size.height < 740 || landscape }

    var scale: CGFloat { FactoryLayout.scale(in: size) }

    /// iPad type stays larger in landscape because it uses the shorter side, not width.
    var text: CGFloat {
        if pad {
            let shortSide = min(size.width, size.height)
            return min(1.42, max(1.22, shortSide / 780))
        }
        return min(1.06, max(0.92, size.height / 852))
    }

    var chromeTop: CGFloat {
        let base: CGFloat = pad ? (landscape ? 36 : 32) : 14
        return max(safeTop, 0) + base
    }

    var chromeSide: CGFloat {
        max(max(safeLeading, safeTrailing), 0) + (pad ? 20 : 12)
    }

    var chromeBottom: CGFloat {
        max(safeBottom, 0) + (pad ? 14 : 8)
    }

    func type(_ base: CGFloat, cap: CGFloat? = nil) -> CGFloat {
        let value = base * text
        if let cap { return min(value, cap) }
        return value
    }

    func art(_ base: CGFloat, cap: CGFloat? = nil) -> CGFloat {
        let value = base * (pad ? min(scale, compact ? 1.15 : 1.35) : 1)
        if let cap { return min(value, cap) }
        return value
    }

    static func make(_ geo: GeometryProxy) -> FactoryMetrics {
        FactoryMetrics(
            size: geo.size,
            safeTop: geo.safeAreaInsets.top,
            safeBottom: geo.safeAreaInsets.bottom,
            safeLeading: geo.safeAreaInsets.leading,
            safeTrailing: geo.safeAreaInsets.trailing
        )
    }

    static let phone = FactoryMetrics(
        size: CGSize(width: 390, height: 844),
        safeTop: 0,
        safeBottom: 34,
        safeLeading: 0,
        safeTrailing: 0
    )
}

private struct FactoryMetricsKey: EnvironmentKey {
    static let defaultValue = FactoryMetrics.phone
}

extension EnvironmentValues {
    var factoryMetrics: FactoryMetrics {
        get { self[FactoryMetricsKey.self] }
        set { self[FactoryMetricsKey.self] = newValue }
    }
}

private struct FactoryReadableWidth: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: sizeClass == .regular ? FactoryLayout.padMaxWidth : FactoryLayout.phoneMaxWidth)
            .frame(maxWidth: .infinity)
    }
}

private struct FactoryLandingWidth: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: sizeClass == .regular ? FactoryLayout.landingMaxWidth : FactoryLayout.phoneMaxWidth)
            .frame(maxWidth: .infinity)
    }
}

private struct FactoryButtonWidth: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: sizeClass == .regular ? FactoryLayout.buttonMaxWidth : .infinity)
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func factoryReadableWidth() -> some View {
        modifier(FactoryReadableWidth())
    }

    func factoryLandingWidth() -> some View {
        modifier(FactoryLandingWidth())
    }

    func factoryButtonWidth() -> some View {
        modifier(FactoryButtonWidth())
    }

    func factoryMetrics(_ metrics: FactoryMetrics) -> some View {
        environment(\.factoryMetrics, metrics)
    }
}
