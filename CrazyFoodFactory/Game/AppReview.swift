import StoreKit
import SwiftUI

enum AppReview {
    static let minDishes = 2
    static let maxAutomaticPrompts = 3
    static let cooldown: TimeInterval = 21 * 24 * 60 * 60

    static func shouldPrompt(save: GameSave) -> Bool {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-screen") || args.contains("-openshare") { return false }
        guard save.dishesCooked >= minDishes else { return false }
        guard save.reviewPromptCount < maxAutomaticPrompts else { return false }
        if save.lastReviewPromptAt > 0 {
            return Date().timeIntervalSince1970 - save.lastReviewPromptAt >= cooldown
        }
        return true
    }
}

extension View {
    func askForReviewIfReady(_ store: GameStateStore, delay: TimeInterval = 1.3) -> some View {
        modifier(ReviewPromptModifier(store: store, delay: delay))
    }
}

private struct ReviewPromptModifier: ViewModifier {
    @ObservedObject var store: GameStateStore
    var delay: TimeInterval
    @Environment(\.requestReview) private var requestReview

    func body(content: Content) -> some View {
        content.onAppear {
            guard AppReview.shouldPrompt(save: store.save) else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard AppReview.shouldPrompt(save: store.save) else { return }
                requestReview()
                store.markReviewPrompted()
            }
        }
    }
}
