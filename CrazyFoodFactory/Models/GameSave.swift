import Foundation

struct GameSave: Codable, Equatable {
    var currentLevel: Int
    var unlockedLevel: Int
    var starsByLevel: [String: Int]
    var completedFoodsByLevel: [String: [String]]
    var totalStars: Int
    var musicEnabled: Bool
    var soundEnabled: Bool
    var speechEnabled: Bool
    var hasSeenTitle: Bool
    var hasSeenHowTo: Bool
    var unlockedRewardIDs: [String]
    var dishesCooked: Int
    var reviewPromptCount: Int
    var lastReviewPromptAt: TimeInterval

    static let blank = GameSave(
        currentLevel: 1,
        unlockedLevel: 1,
        starsByLevel: [:],
        completedFoodsByLevel: [:],
        totalStars: 0,
        musicEnabled: true,
        soundEnabled: true,
        speechEnabled: true,
        hasSeenTitle: false,
        hasSeenHowTo: false,
        unlockedRewardIDs: [],
        dishesCooked: 0,
        reviewPromptCount: 0,
        lastReviewPromptAt: 0
    )

    enum CodingKeys: String, CodingKey {
        case currentLevel, unlockedLevel, starsByLevel, completedFoodsByLevel
        case totalStars, musicEnabled, soundEnabled, speechEnabled
        case hasSeenTitle, hasSeenHowTo, unlockedRewardIDs
        case dishesCooked, reviewPromptCount, lastReviewPromptAt
    }

    init(
        currentLevel: Int,
        unlockedLevel: Int,
        starsByLevel: [String: Int],
        completedFoodsByLevel: [String: [String]],
        totalStars: Int,
        musicEnabled: Bool,
        soundEnabled: Bool,
        speechEnabled: Bool,
        hasSeenTitle: Bool,
        hasSeenHowTo: Bool,
        unlockedRewardIDs: [String],
        dishesCooked: Int = 0,
        reviewPromptCount: Int = 0,
        lastReviewPromptAt: TimeInterval = 0
    ) {
        self.currentLevel = currentLevel
        self.unlockedLevel = unlockedLevel
        self.starsByLevel = starsByLevel
        self.completedFoodsByLevel = completedFoodsByLevel
        self.totalStars = totalStars
        self.musicEnabled = musicEnabled
        self.soundEnabled = soundEnabled
        self.speechEnabled = speechEnabled
        self.hasSeenTitle = hasSeenTitle
        self.hasSeenHowTo = hasSeenHowTo
        self.unlockedRewardIDs = unlockedRewardIDs
        self.dishesCooked = dishesCooked
        self.reviewPromptCount = reviewPromptCount
        self.lastReviewPromptAt = lastReviewPromptAt
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
        speechEnabled = try container.decodeIfPresent(Bool.self, forKey: .speechEnabled) ?? true
        hasSeenTitle = try container.decodeIfPresent(Bool.self, forKey: .hasSeenTitle) ?? false
        hasSeenHowTo = try container.decodeIfPresent(Bool.self, forKey: .hasSeenHowTo) ?? false
        unlockedRewardIDs = try container.decodeIfPresent([String].self, forKey: .unlockedRewardIDs) ?? []
        dishesCooked = try container.decodeIfPresent(Int.self, forKey: .dishesCooked) ?? 0
        reviewPromptCount = try container.decodeIfPresent(Int.self, forKey: .reviewPromptCount) ?? 0
        lastReviewPromptAt = try container.decodeIfPresent(TimeInterval.self, forKey: .lastReviewPromptAt) ?? 0
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
        let speech = speechEnabled
        let reviews = reviewPromptCount
        let lastReview = lastReviewPromptAt
        self = .blank
        musicEnabled = music
        soundEnabled = sound
        speechEnabled = speech
        hasSeenTitle = true
        hasSeenHowTo = true
        reviewPromptCount = reviews
        lastReviewPromptAt = lastReview
    }

    mutating func unlockRewards(for food: FoodType) {
        var ids = Set(unlockedRewardIDs)
        ids.insert("food-\(food.rawValue)")
        for reward in RewardCatalog.all where reward.starsNeeded > 0 && totalStars >= reward.starsNeeded {
            ids.insert(reward.id)
        }
        unlockedRewardIDs = Array(ids).sorted()
    }

    private mutating func recalcStars() {
        totalStars = starsByLevel.values.reduce(0, +)
    }
}
