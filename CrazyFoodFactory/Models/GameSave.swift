import Foundation

struct GameSave: Codable, Equatable {
    var currentLevel: Int
    var unlockedLevel: Int
    var starsByLevel: [String: Int]
    var completedFoodsByLevel: [String: [String]]
    var totalStars: Int
    var musicEnabled: Bool
    var soundEnabled: Bool
    var hasSeenTitle: Bool

    static let blank = GameSave(
        currentLevel: 1,
        unlockedLevel: 1,
        starsByLevel: [:],
        completedFoodsByLevel: [:],
        totalStars: 0,
        musicEnabled: true,
        soundEnabled: true,
        hasSeenTitle: false
    )

    func stars(for level: Int) -> Int {
        starsByLevel["\(level)"] ?? 0
    }

    func completedFoods(for level: Int) -> [FoodType] {
        (completedFoodsByLevel["\(level)"] ?? []).compactMap(FoodType.init(rawValue:))
    }

    mutating func markFood(_ food: FoodType, level: Int, stars: Int) {
        let key = "\(level)"
        var foods = completedFoods(for: level)
        if !foods.contains(food) {
            foods.append(food)
        }
        completedFoodsByLevel[key] = foods.map(\.rawValue)
        let previous = self.stars(for: level)
        let next = max(previous, stars)
        starsByLevel[key] = next
        recalcStars()
    }

    mutating func completeLevel(_ level: Int, stars: Int) {
        let previous = self.stars(for: level)
        starsByLevel["\(level)"] = max(previous, stars)
        if unlockedLevel == level {
            unlockedLevel = min(LevelCatalog.levelCount, level + 1)
        }
        currentLevel = min(LevelCatalog.levelCount, level + 1)
        recalcStars()
    }

    mutating func resetProgress() {
        let music = musicEnabled
        let sound = soundEnabled
        self = .blank
        musicEnabled = music
        soundEnabled = sound
        hasSeenTitle = true
    }

    private mutating func recalcStars() {
        totalStars = starsByLevel.values.reduce(0, +)
    }
}
