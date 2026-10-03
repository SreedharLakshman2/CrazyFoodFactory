import Foundation
import SwiftUI

@MainActor
final class GameStateStore: ObservableObject {
    @Published var save: GameSave
    @Published var selectedFood: FoodType = .pizza
    @Published var currentResult: FoodResult?
    @Published var lastChaos: ChaosEvent?
    @Published var sessionCompleted: [FoodType] = []
    @Published var pendingKeepCrazy = false

    private let defaultsKey = "cff.game.save.v1"

    static let preview: GameStateStore = {
        let store = GameStateStore()
        store.save.unlockedLevel = 4
        store.save.starsByLevel = ["1": 3, "2": 3, "3": 2, "4": 1]
        store.save.totalStars = 9
        return store
    }()

    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode(GameSave.self, from: data) {
            save = decoded
        } else {
            save = .blank
        }
    }

    var currentLevel: LevelDefinition {
        LevelCatalog.level(save.currentLevel)
    }

    var remainingFoods: [FoodType] {
        currentLevel.requiredFoods.filter { !sessionCompleted.contains($0) }
    }

    var levelFinished: Bool {
        remainingFoods.isEmpty && !currentLevel.requiredFoods.isEmpty
    }

    enum AfterDish {
        case play
        case pickFood
        case worldDone
    }

    /// After a cooked dish: next leftover in this level, else open the next kitchen.
    func advanceAfterDish() -> AfterDish {
        if let next = nextFood() {
            select(next)
            return .play
        }

        let finishingLast = save.currentLevel >= LevelCatalog.levelCount
        if completeLevelIfNeeded() {
            if finishingLast {
                return .worldDone
            }
            return openCurrentKitchen()
        }
        return .pickFood
    }

    /// Level Complete already incremented the save. Start that kitchen.
    func continueAfterLevelComplete() -> AfterDish {
        if save.currentLevel >= LevelCatalog.levelCount && remainingFoods.isEmpty {
            startLevel(save.currentLevel)
            if nextFood() == nil {
                return .worldDone
            }
        }
        return openCurrentKitchen()
    }

    @discardableResult
    private func openCurrentKitchen() -> AfterDish {
        startLevel(save.currentLevel)
        if currentLevel.requiredFoods.count > 1 {
            return .pickFood
        }
        if let food = currentLevel.requiredFoods.first {
            select(food)
            return .play
        }
        return .pickFood
    }

    func persist() {
        if let data = try? JSONEncoder().encode(save) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    func startLevel(_ id: Int) {
        save.currentLevel = id
        sessionCompleted = save.completedFoods(for: id)
        currentResult = nil
        lastChaos = nil
        persist()
    }

    func select(_ food: FoodType) {
        selectedFood = food
    }

    func definition(for food: FoodType) -> FoodGameDefinition {
        FoodCatalog.definition(for: food, level: currentLevel)
    }

    func applyResult(_ result: FoodResult) {
        currentResult = result
        save.dishesCooked += 1
        if currentLevel.requiredFoods.contains(result.food) {
            if !sessionCompleted.contains(result.food) {
                sessionCompleted.append(result.food)
            }
            save.markFood(result.food, level: save.currentLevel, stars: result.stars)
            save.unlockRewards(for: result.food)
            persist()
        } else {
            save.unlockRewards(for: result.food)
            persist()
        }
    }

    func completeLevelIfNeeded() -> Bool {
        guard levelFinished else { return false }
        let stars = max(1, min(3, 3 - (lastChaos == nil ? 0 : 1)))
        save.completeLevel(save.currentLevel, stars: max(stars, currentResult?.stars ?? 1))
        persist()
        return true
    }

    func nextFood() -> FoodType? {
        remainingFoods.first
    }

    func resetProgress() {
        save.resetProgress()
        sessionCompleted = []
        currentResult = nil
        persist()
    }

    func setMusic(_ on: Bool) {
        save.musicEnabled = on
        persist()
        AudioManager.shared.applySettings(music: save.musicEnabled, sound: save.soundEnabled, speech: save.speechEnabled)
    }

    func setSpeech(_ on: Bool) {
        save.speechEnabled = on
        persist()
        AudioManager.shared.applySettings(music: save.musicEnabled, sound: save.soundEnabled, speech: save.speechEnabled)
    }

    func markSeenHowTo() {
        save.hasSeenHowTo = true
        save.hasSeenTitle = true
        persist()
    }

    func markReviewPrompted() {
        save.reviewPromptCount += 1
        save.lastReviewPromptAt = Date().timeIntervalSince1970
        persist()
    }

    func setSound(_ on: Bool) {
        save.soundEnabled = on
        persist()
        AudioManager.shared.applySettings(music: save.musicEnabled, sound: save.soundEnabled, speech: save.speechEnabled)
    }
}
