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
    var hasSeenHowTo: Bool

    static let blank = GameSave(
        currentLevel: 1,
        unlockedLevel: 1,
        starsByLevel: [:],
        completedFoodsByLevel: [:],
        totalStars: 0,
        musicEnabled: true,
        soundEnabled: true,
        hasSeenTitle: false,
        hasSeenHowTo: false
    )

    enum CodingKeys: String, CodingKey {
        case currentLevel, unlockedLevel, starsByLevel, completedFoodsByLevel
        case totalStars, musicEnabled, soundEnabled, hasSeenTitle, hasSeenHowTo
    }

    init(
        currentLevel: Int,
        unlockedLevel: Int,
        starsByLevel: [String: Int],
        completedFoodsByLevel: [String: [String]],
        totalStars: Int,
        musicEnabled: Bool,
        soundEnabled: Bool,
        hasSeenTitle: Bool,
        hasSeenHowTo: Bool
    ) {
        self.currentLevel = currentLevel
        self.unlockedLevel = unlockedLevel
        self.starsByLevel = starsByLevel
        self.completedFoodsByLevel = completedFoodsByLevel
        self.totalStars = totalStars
        self.musicEnabled = musicEnabled
        self.soundEnabled = soundEnabled
        self.hasSeenTitle = hasSeenTitle
        self.hasSeenHowTo = hasSeenHowTo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentLevel = try container.decodeIfPresent(Int.self, forKey: .currentLevel) ?? 1
        unlockedLevel = try container.decodeIfPresent(Int.self, forKey: .unlockedLevel) ?? 1
        starsByLevel = try container.decodeIfPresent([String: Int].self, forKey: .starsByLevel) ?? [:]
        completedFoodsByLevel = try container.decodeIfPresent([String: [String]].self, forKey: .completedFoodsByLevel) ?? [:]
        totalStars = try container.decodeIfPresent(Int.self, forKey: .totalStars) ?? 0
        musicEnabled = try container.decodeIfPresent(Bool.self, forKey: .musicEnabled) ?? true
        soundEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundEnabled) ?? true
        hasSeenTitle = try container.decodeIfPresent(Bool.self, forKey: .hasSeenTitle) ?? false
        hasSeenHowTo = try container.decodeIfPresent(Bool.self, forKey: .hasSeenHowTo) ?? false
    }

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
        hasSeenHowTo = true
    }

    private mutating func recalcStars() {
        totalStars = starsByLevel.values.reduce(0, +)
    }
}
