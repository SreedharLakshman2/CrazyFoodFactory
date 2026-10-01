import Foundation

enum LevelCatalog {
    static let levelCount = 21
    static let maxStars = levelCount * 3

    static let all: [LevelDefinition] = [
        LevelDefinition(id: 1, title: "Pizza Line", requiredFoods: [.pizza], chaosChance: 0.08, extraIngredients: false),
        LevelDefinition(id: 2, title: "Burger Belt", requiredFoods: [.burger], chaosChance: 0.08, extraIngredients: false),
        LevelDefinition(id: 3, title: "Scoop Station", requiredFoods: [.iceCream], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 4, title: "Donut Decor", requiredFoods: [.donut], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 5, title: "Sandwich Stack", requiredFoods: [.sandwich], chaosChance: 0.10, extraIngredients: false),
        LevelDefinition(id: 6, title: "Taco Truck", requiredFoods: [.taco], chaosChance: 0.12, extraIngredients: false),
        LevelDefinition(id: 7, title: "Pasta Party", requiredFoods: [.pasta], chaosChance: 0.12, extraIngredients: true),
        LevelDefinition(id: 8, title: "Sweet Shop", requiredFoods: [.cupcake, .cookies], chaosChance: 0.14, extraIngredients: true),
        LevelDefinition(id: 9, title: "Breakfast Club", requiredFoods: [.pancakes, .smoothie], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 10, title: "Garden Bowl", requiredFoods: [.salad], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 11, title: "Ballpark", requiredFoods: [.hotDog, .burger], chaosChance: 0.18, extraIngredients: true),
        LevelDefinition(id: 12, title: "Dosa Line", requiredFoods: [.dosa, .idli], chaosChance: 0.14, extraIngredients: false),
        LevelDefinition(id: 13, title: "Sambar Shop", requiredFoods: [.sambar, .vada], chaosChance: 0.14, extraIngredients: true),
        LevelDefinition(id: 14, title: "Spice Route", requiredFoods: [.biryani, .paneerTikka, .naanWrap], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 15, title: "Curry Club", requiredFoods: [.chole, .palak], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 16, title: "Mango Sip", requiredFoods: [.mangoLassi], chaosChance: 0.14, extraIngredients: true),
        LevelDefinition(id: 17, title: "Nacho Fiesta", requiredFoods: [.nachos, .quesadilla], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 18, title: "Wrap Wagon", requiredFoods: [.burrito, .guacamole, .elote], chaosChance: 0.18, extraIngredients: true),
        LevelDefinition(id: 19, title: "Noodle World", requiredFoods: [.ramen, .sushiRoll], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 20, title: "Street Bites", requiredFoods: [.falafel, .hummus], chaosChance: 0.16, extraIngredients: true),
        LevelDefinition(id: 21, title: "World Finale", requiredFoods: [.dosa, .burrito, .ramen, .mangoLassi], chaosChance: 0.20, extraIngredients: true)
    ]

    static func level(_ id: Int) -> LevelDefinition {
        all.first(where: { $0.id == id }) ?? all[0]
    }
}
