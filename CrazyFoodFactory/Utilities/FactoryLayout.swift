import SwiftUI

enum FactoryLayout {
    static let phoneMaxWidth: CGFloat = 430
    static let padMaxWidth: CGFloat = 720
    static let buttonMaxWidth: CGFloat = 440
    static let overlayMaxWidth: CGFloat = 560

    static func isRegular(_ size: CGSize) -> Bool {
        min(size.width, size.height) >= 600 || max(size.width, size.height) >= 1000
    }

    static func contentWidth(in size: CGSize) -> CGFloat {
        if isRegular(size) {
            return min(size.width - 40, padMaxWidth)
        }
        return min(size.width, phoneMaxWidth)
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

    func factoryButtonWidth() -> some View {
        modifier(FactoryButtonWidth())
    }
}
