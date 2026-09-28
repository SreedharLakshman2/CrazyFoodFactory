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
                    guard router.screen == .splash else { return }
                    if store.save.hasSeenHowTo {
                        router.go(.home)
                    } else {
                        router.go(.howTo)
                    }
                }
            case .howTo:
                HowToPlayView {
                    store.markSeenHowTo()
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
                    ChaosEventView(
                        event: chaos,
                        food: store.selectedFood,
                        melted: chaos.type == .meltedIceCream,
                        keep: { router.go(.gameplay) },
                        retry: { router.go(.gameplay) }
                    )
                } else {
                    FoodSelectionView()
                }
            case .result:
                ResultView()
            case .levelComplete:
                LevelCompleteView()
            case .levelMap:
                LevelMapView()
            case .rewards:
                RewardsView()
            case .settings:
                SettingsView()
            }
        }
        .background(FactoryBackground())
        .sheet(isPresented: $router.showSettings) {
            SettingsView()
                .environmentObject(store)
                .environmentObject(router)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(.light)
        .statusBarHidden(true)
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            DispatchQueue.main.async {
                applyLaunchArguments()
                AudioManager.shared.prepare()
                AudioManager.shared.applySettings(
                    music: false,
                    sound: store.save.soundEnabled,
                    speech: store.save.speechEnabled
                )
                if ProcessInfo.processInfo.arguments.contains("-selftest") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        let report = KitchenFlowSelfTest.runAll()
                        let url = FileManager.default.temporaryDirectory.appendingPathComponent("kido-selftest.txt")
                        try? report.write(to: url, atomically: true, encoding: .utf8)
                        print(report)
                        print("SELFTEST_PATH \(url.path)")
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                let allowMusic = store.save.musicEnabled
                    && router.screen != .splash
                    && router.screen != .howTo
                AudioManager.shared.applySettings(
                    music: allowMusic,
                    sound: store.save.soundEnabled,
                    speech: store.save.speechEnabled
                )
            case .inactive, .background:
                AudioManager.shared.stopMusic()
            default:
                break
            }
        }
    }

    private func applyLaunchArguments() {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: "-screen"), args.indices.contains(index + 1) else { return }
        var components = URLComponents()
        components.scheme = "crazyfood"
        components.host = args[index + 1]
        if let foodIndex = args.firstIndex(of: "-food"), args.indices.contains(foodIndex + 1) {
            components.queryItems = [URLQueryItem(name: "food", value: args[foodIndex + 1])]
        }
        if let typeIndex = args.firstIndex(of: "-type"), args.indices.contains(typeIndex + 1) {
            var items = components.queryItems ?? []
            items.append(URLQueryItem(name: "type", value: args[typeIndex + 1]))
            components.queryItems = items
        }
        if let url = components.url {
            handleDeepLink(url)
        }
    }

    private func handleDeepLink(_ url: URL) {
        switch url.host {
        case "howto", "learn", "onboard":
            router.go(.howTo)
        case "home":
            router.go(.home)
        case "select", "foods":
            router.go(.foodSelection)
        case "play":
            store.select(queryFood(url) ?? store.selectedFood)
            router.go(.gameplay)
        case "result":
            let food = queryFood(url) ?? store.selectedFood
            store.selectedFood = food
            store.currentResult = FoodResult(
                food: food,
                stars: 3,
                placed: FoodCatalog.definition(for: food, level: store.currentLevel).checklist,
                keptCrazy: false,
                title: food.resultTitle,
                message: "Yummy!"
            )
            router.go(.result)
        case "complete":
            if store.sessionCompleted.isEmpty {
                store.sessionCompleted = store.currentLevel.requiredFoods
            }
            if store.currentResult == nil {
                store.currentResult = FoodResult(
                    food: store.sessionCompleted.first ?? .pizza,
                    stars: 3,
                    placed: [],
                    keptCrazy: false,
                    title: "Yummy!",
                    message: "Yummy!"
                )
            }
            router.go(.levelComplete)
        case "map":
            router.go(.levelMap)
        case "rewards":
            router.go(.rewards)
        case "settings":
            router.showSettings = true
        case "chaos":
            switch queryValue(url, "type") {
            case "melted":
                store.lastChaos = .meltedIceCream
                store.selectedFood = .iceCream
            case "penguin":
                store.lastChaos = .penguinVisit
                store.selectedFood = .donut
            default:
                store.lastChaos = .pineapplePizza
                store.selectedFood = .pizza
            }
            router.go(.chaos)
        default:
            break
        }
    }

    private func queryValue(_ url: URL, _ name: String) -> String? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == name })?
            .value
    }

    private func queryFood(_ url: URL) -> FoodType? {
        guard let raw = queryValue(url, "food")?.lowercased() else { return nil }
        switch raw {
        case "pizza": return .pizza
        case "burger": return .burger
        case "icecream", "ice-cream", "ice_cream": return .iceCream
        case "donut", "donuts": return .donut
        case "sandwich": return .sandwich
        case "taco": return .taco
        case "pasta": return .pasta
        case "cupcake": return .cupcake
        case "hotdog", "hot-dog", "hot_dog": return .hotDog
        case "pancakes", "pancake": return .pancakes
        case "salad": return .salad
        case "smoothie": return .smoothie
        case "cookies", "cookie": return .cookies
        default: return FoodType(rawValue: raw)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppRouter())
        .environmentObject(GameStateStore.preview)
}
