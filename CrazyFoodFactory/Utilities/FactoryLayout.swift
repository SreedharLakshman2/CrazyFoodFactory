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
}
