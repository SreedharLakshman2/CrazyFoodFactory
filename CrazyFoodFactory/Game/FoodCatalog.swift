import Foundation

enum FoodCatalog {
    static func definition(for food: FoodType, level: LevelDefinition) -> FoodGameDefinition {
        let extra = level.extraIngredients || level.id >= 6
        switch food {
        case .pizza: return pizza(extra: extra)
        case .burger: return burger(extra: extra)
        case .iceCream: return iceCream(extra: extra)
        case .donut: return donut(extra: extra)
        case .sandwich: return sandwich(extra: extra)
        }
    }

    private static func pizza(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .tomatoSauce),
            Ingredient(id: .cheese),
            Ingredient(id: .pepperoni),
            Ingredient(id: .mushroom)
        ]
        tray.append(Ingredient(id: .pineapple, isChaosBait: true, isOptional: true))
        if extra { tray.insert(Ingredient(id: .onion, isOptional: true), at: 3) }

        return FoodGameDefinition(
            id: .pizza,
            type: .pizza,
            title: FoodType.pizza.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "sauce", accepted: [.tomatoSauce], hint: "Sauce first!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Cheesy please!"),
                GameStep(
                    id: "toppings",
                    accepted: extra ? [.pepperoni, .mushroom, .onion, .pineapple] : [.pepperoni, .mushroom, .pineapple],
                    minCount: extra ? 2 : 1,
                    chaosIngredients: [.pineapple],
                    hint: "Add toppings!"
                ),
                GameStep(id: "oven", accepted: [], isOven: true, hint: "Into the oven!")
            ],
            prePlaced: [.dough],
            showsOven: true,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.dough, .tomatoSauce, .cheese, .pepperoni]
        )
    }

    private static func burger(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .bun),
            Ingredient(id: .patty),
            Ingredient(id: .cheese),
            Ingredient(id: .lettuce),
            Ingredient(id: .tomato),
            Ingredient(id: .topBun)
        ]
        if extra { tray.insert(Ingredient(id: .onion, isOptional: true), at: 5) }

        return FoodGameDefinition(
            id: .burger,
            type: .burger,
            title: FoodType.burger.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "bun", accepted: [.bun]),
                GameStep(id: "patty", accepted: [.patty]),
                GameStep(id: "cheese", accepted: [.cheese]),
                GameStep(id: "lettuce", accepted: [.lettuce]),
                GameStep(id: "tomato", accepted: extra ? [.tomato, .onion] : [.tomato]),
                GameStep(id: "top", accepted: [.topBun])
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.bun, .patty, .lettuce, .cheese]
        )
    }

    private static func iceCream(extra: Bool) -> FoodGameDefinition {
        var flavors: [Ingredient] = [
            Ingredient(id: .vanilla),
            Ingredient(id: .strawberry),
            Ingredient(id: .chocolate)
        ]
        if extra { flavors.append(Ingredient(id: .mint)) }

        return FoodGameDefinition(
            id: .iceCream,
            type: .iceCream,
            title: FoodType.iceCream.taskTitle,
            ingredients: [Ingredient(id: .cone)] + flavors + [
                Ingredient(id: .sprinkles),
                Ingredient(id: .cherry, isOptional: true)
            ],
            steps: [
                GameStep(id: "cone", accepted: [.cone], hint: "Pick a cone!"),
                GameStep(id: "flavor", accepted: extra ? [.vanilla, .strawberry, .chocolate, .mint] : [.vanilla, .strawberry, .chocolate], hint: "Pick a flavor!"),
                GameStep(id: "scoop2", accepted: extra ? [.vanilla, .strawberry, .chocolate, .mint, .scoop] : [.vanilla, .strawberry, .chocolate, .scoop], hint: "One more scoop!"),
                GameStep(id: "top", accepted: [.sprinkles, .cherry], hint: "Sprinkle time!")
            ],
            prePlaced: [],
            showsOven: true,
            ovenIsTrap: true,
            strictOrder: true,
            checklist: [.cone, .vanilla, .sprinkles]
        )
    }

    private static func donut(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .donut,
            type: .donut,
            title: FoodType.donut.taskTitle,
            ingredients: [
                Ingredient(id: .chocolateFrosting),
                Ingredient(id: .strawberryFrosting),
                Ingredient(id: .vanillaFrosting),
                Ingredient(id: .sprinkles),
                Ingredient(id: .rainbowCandy)
            ],
            steps: [
                GameStep(
                    id: "frosting",
                    accepted: [.chocolateFrosting, .strawberryFrosting, .vanillaFrosting],
                    hint: "Pick a frosting!"
                ),
                GameStep(
                    id: "toppings",
                    accepted: [.sprinkles, .rainbowCandy],
                    minCount: extra ? 2 : 1,
                    hint: "Tap to add toppings!"
                )
            ],
            prePlaced: [.donutBase],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: false,
            checklist: [.donutBase, .strawberryFrosting, .sprinkles]
        )
    }

    private static func sandwich(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .bread),
            Ingredient(id: .lettuce),
            Ingredient(id: .tomato),
            Ingredient(id: .cheese),
            Ingredient(id: .ham),
            Ingredient(id: .topBread)
        ]
        if extra { tray.insert(Ingredient(id: .onion, isOptional: true), at: 4) }

        return FoodGameDefinition(
            id: .sandwich,
            type: .sandwich,
            title: FoodType.sandwich.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "bread", accepted: [.bread]),
                GameStep(id: "lettuce", accepted: [.lettuce]),
                GameStep(id: "tomato", accepted: [.tomato]),
                GameStep(id: "cheese", accepted: extra ? [.cheese, .onion] : [.cheese]),
                GameStep(id: "ham", accepted: [.ham]),
                GameStep(id: "top", accepted: [.topBread])
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.bread, .lettuce, .tomato, .cheese]
        )
    }
}
