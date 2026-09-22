import Foundation

struct LevelDefinition: Identifiable, Equatable {
    let id: Int
    let title: String
    let requiredFoods: [FoodType]
    let chaosChance: Double
    let extraIngredients: Bool

    var nodeFood: FoodType {
        requiredFoods.first ?? .pizza
    }
}

struct FoodResult: Equatable {
    let food: FoodType
    let stars: Int
    let placed: [IngredientID]
    let keptCrazy: Bool
    let title: String
    let message: String
}
