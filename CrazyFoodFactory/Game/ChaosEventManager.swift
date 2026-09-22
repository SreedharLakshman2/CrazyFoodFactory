import Foundation

@MainActor
final class ChaosEventManager {
    static let shared = ChaosEventManager()

    private var lastEventAt: Date = .distantPast
    private let cooldown: TimeInterval = 14

    private init() {}

    func event(for type: ChaosEventType) -> ChaosEvent {
        switch type {
        case .pineapplePizza: return .pineapplePizza
        case .meltedIceCream: return .meltedIceCream
        case .burntFood: return .burntFood
        case .wrongIngredient: return .wrongIngredient
        case .ingredientExplosion: return .ingredientExplosion
        case .foodTooBig: return .foodTooBig
        case .foodTooSmall: return .foodTooSmall
        case .chefSlip: return .chefSlip
        case .penguinVisit: return .penguinVisit
        }
    }

    func maybeRandom(chance: Double, alreadyTriggered: Bool) -> ChaosEvent? {
        guard !alreadyTriggered else { return nil }
        guard Date().timeIntervalSince(lastEventAt) > cooldown else { return nil }
        guard Double.random(in: 0...1) < chance else { return nil }
        lastEventAt = Date()
        let pool: [ChaosEventType] = [
            .ingredientExplosion, .chefSlip, .penguinVisit, .foodTooBig, .foodTooSmall, .burntFood
        ]
        return event(for: pool.randomElement() ?? .chefSlip)
    }

    func resetCooldown() {
        lastEventAt = .distantPast
    }
}
