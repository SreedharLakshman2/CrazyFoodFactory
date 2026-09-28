import SwiftUI

@main
struct CrazyFoodFactoryApp: App {
    @StateObject private var store = GameStateStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(router)
                .dynamicTypeSize(.medium ... .accessibility3)
                .persistentSystemOverlays(.hidden)
                .statusBarHidden(true)
                .background(Color(red: 0.361, green: 0.784, blue: 1).ignoresSafeArea())
        }
    }
}
