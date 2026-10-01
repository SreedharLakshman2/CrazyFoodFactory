import Foundation

struct Reward: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let food: FoodType?
    let starsNeeded: Int
}

enum RewardCatalog {
    static let all: [Reward] = FoodType.allCases.map { food in
        Reward(
            id: "food-\(food.rawValue)",
            title: "\(food.displayName) Star",
            subtitle: "You cooked \(food.displayName)!",
            food: food,
            starsNeeded: 0
        )
    } + [
        Reward(id: "stars-5", title: "Rising Chef", subtitle: "5 stars in the kitchen!", food: nil, starsNeeded: 5),
        Reward(id: "stars-12", title: "Kitchen Hero", subtitle: "12 shiny stars!", food: nil, starsNeeded: 12),
        Reward(id: "stars-21", title: "Master Mixer", subtitle: "21 stars. Wow!", food: nil, starsNeeded: 21),
        Reward(id: "stars-30", title: "Kido Legend", subtitle: "30 stars. Super chef!", food: nil, starsNeeded: 30),
        Reward(id: "stars-45", title: "World Cook", subtitle: "45 stars around the world!", food: nil, starsNeeded: 45)
    ]
}
