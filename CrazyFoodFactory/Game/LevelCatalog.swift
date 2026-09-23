import Foundation

enum LevelCatalog {
    static let levelCount = 10
    static let maxStars = levelCount * 3

    static let all: [LevelDefinition] = [
        LevelDefinition(id: 1, title: "Pizza Line", requiredFoods: [.pizza], chaosChance: 0.08, extraIngredients: false),
        LevelDefinition(id: 2, title: "Burger Belt", requiredFoods: [.burger], chaosChance: 0.08, extraIngredients: false),
        LevelDefinition(id: 3, title: "Scoop Station", requiredFoods: [.iceCream], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 4, title: "Donut Decor", requiredFoods: [.donut], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 5, title: "Sandwich Stack", requiredFoods: [.sandwich], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 6, title: "Taco Truck", requiredFoods: [.taco], chaosChance: 0.12, extraIngredients: false),
        LevelDefinition(id: 7, title: "Pasta Party", requiredFoods: [.pasta, .pizza], chaosChance: 0.14, extraIngredients: true),
        LevelDefinition(id: 8, title: "Sweet Shop", requiredFoods: [.cupcake, .donut], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 9, title: "Ballpark", requiredFoods: [.hotDog, .burger], chaosChance: 0.18, extraIngredients: true),
        LevelDefinition(id: 10, title: "Factory Finale", requiredFoods: FoodType.allCases, chaosChance: 0.20, extraIngredients: true)
    ]

    static func level(_ id: Int) -> LevelDefinition {
        all.first(where: { $0.id == id }) ?? all[0]
    }
}
