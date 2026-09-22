import SwiftUI

struct RootView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var store: GameStateStore
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            switch router.screen {
            case .splash:
                SplashView {
                    router.go(.home)
                }
            case .home:
                HomeView()
            case .foodSelection:
                FoodSelectionView()
            case .gameplay:
                GameplayView(
                    definition: store.definition(for: store.selectedFood),
                    level: store.currentLevel
                )
                .id("\(store.selectedFood.rawValue)-\(store.save.currentLevel)-\(store.sessionCompleted.count)")
            case .chaos:
                if let chaos = store.lastChaos {
                    ChaosEventView(event: chaos, food: store.selectedFood, keep: {}, retry: {})
                } else {
                    FoodSelectionView()
                }
            case .result:
                ResultView()
            case .levelComplete:
                LevelCompleteView()
            case .levelMap:
                LevelMapView()
            case .settings:
                SettingsView()
            }
        }
        .sheet(isPresented: $router.showSettings) {
            SettingsView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(.light)
        .statusBarHidden(true)
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            AudioManager.shared.prepare()
            AudioManager.shared.applySettings(music: store.save.musicEnabled, sound: store.save.soundEnabled)
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                AudioManager.shared.applySettings(music: store.save.musicEnabled, sound: store.save.soundEnabled)
            case .inactive, .background:
                AudioManager.shared.stopMusic()
            default:
                break
            }
        }
    }

    private func handleDeepLink(_ url: URL) {
        switch url.host {
        case "home":
            router.go(.home)
        case "select", "foods":
            router.go(.foodSelection)
        case "play":
            let food = FoodType(rawValue: URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "food" })?.value ?? "") ?? store.selectedFood
            store.select(food)
            router.go(.gameplay)
        case "result":
            if store.currentResult == nil {
                store.currentResult = FoodResult(
                    food: store.selectedFood,
                    stars: 3,
                    placed: [.bun, .patty, .cheese, .lettuce],
                    keptCrazy: false,
                    title: store.selectedFood.resultTitle,
                    message: "Yummy!"
                )
            }
            router.go(.result)
        case "complete":
            router.go(.levelComplete)
        case "map":
            router.go(.levelMap)
        case "settings":
            router.showSettings = true
        case "chaos":
            store.lastChaos = .pineapplePizza
            router.go(.chaos)
        default:
            break
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
