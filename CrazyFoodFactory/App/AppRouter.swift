import SwiftUI

enum AppScreen: Equatable {
    case splash
    case howTo
    case home
    case foodSelection
    case gameplay
    case chaos
    case result
    case levelComplete
    case levelMap
    case rewards
    case settings
    case ingredientSchool
}

@MainActor
final class AppRouter: ObservableObject {
    @Published var screen: AppScreen = .splash
    @Published var showSettings = false
    @Published var showPause = false

    func go(_ next: AppScreen) {
        withAnimation(.spring(response: 0.46, dampingFraction: 0.84)) {
            screen = next
            if next != .gameplay {
                showPause = false
            }
        }
    }
}
