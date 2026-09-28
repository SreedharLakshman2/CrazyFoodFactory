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
        case .taco: return taco(extra: extra)
        case .pasta: return pasta(extra: extra)
        case .cupcake: return cupcake(extra: extra)
        case .hotDog: return hotDog(extra: extra)
        case .pancakes: return pancakes(extra: extra)
        case .salad: return salad(extra: extra)
        case .smoothie: return smoothie(extra: extra)
        case .cookies: return cookies(extra: extra)
        }
    }

    private static func pizza(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .tomato),
            Ingredient(id: .cheese),
            Ingredient(id: .greenPepper),
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
                GameStep(id: "tomato", accepted: [.tomato], hint: "Tomato first!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Cheesy please!"),
                GameStep(
                    id: "toppings",
                    accepted: extra ? [.greenPepper, .mushroom, .onion, .pineapple] : [.greenPepper, .mushroom, .pineapple],
                    minCount: extra ? 2 : 1,
                    chaosIngredients: [.pineapple],
                    hint: "Add toppings!"
                )
            ],
            prePlaced: [.dough],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.tomato, .cheese, .greenPepper, .mushroom]
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

    private static func taco(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .tortilla),
            Ingredient(id: .lettuce),
            Ingredient(id: .tacoBeef),
            Ingredient(id: .cheese),
            Ingredient(id: .salsa)
        ]
        if extra { tray.append(Ingredient(id: .avocado, isOptional: true)) }
        return FoodGameDefinition(
            id: .taco,
            type: .taco,
            title: FoodType.taco.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "shell", accepted: [.tortilla], hint: "Start with a shell!"),
                GameStep(id: "beef", accepted: [.tacoBeef], hint: "Add the beef!"),
                GameStep(id: "veg", accepted: extra ? [.lettuce, .avocado] : [.lettuce], hint: "Green and crunchy!"),
                GameStep(id: "top", accepted: [.cheese, .salsa], minCount: 1, hint: "Cheese or salsa!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.tortilla, .tacoBeef, .lettuce, .cheese]
        )
    }

    private static func pasta(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .pasta,
            type: .pasta,
            title: FoodType.pasta.taskTitle,
            ingredients: [
                Ingredient(id: .noodles),
                Ingredient(id: .tomatoSauce),
                Ingredient(id: .meatball),
                Ingredient(id: .cheese),
                Ingredient(id: .basil, isOptional: true)
            ],
            steps: [
                GameStep(id: "noodles", accepted: [.noodles], hint: "Noodles first!"),
                GameStep(id: "sauce", accepted: [.tomatoSauce], hint: "Sauce splash!"),
                GameStep(id: "meat", accepted: extra ? [.meatball, .cheese] : [.meatball], hint: "Add a meatball!"),
                GameStep(id: "herb", accepted: [.basil, .cheese], minCount: 1, hint: "Cheesy finish!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.noodles, .tomatoSauce, .meatball, .cheese]
        )
    }

    private static func cupcake(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .cupcake,
            type: .cupcake,
            title: FoodType.cupcake.taskTitle,
            ingredients: [
                Ingredient(id: .cupcakeBase),
                Ingredient(id: .cupcakeFrosting),
                Ingredient(id: .sprinkles),
                Ingredient(id: .cherry),
                Ingredient(id: .candle, isOptional: true)
            ],
            steps: [
                GameStep(id: "cake", accepted: [.cupcakeBase], hint: "Little cake first!"),
                GameStep(id: "frost", accepted: [.cupcakeFrosting], hint: "Swirl the frosting!"),
                GameStep(
                    id: "top",
                    accepted: extra ? [.sprinkles, .cherry, .candle] : [.sprinkles, .cherry],
                    minCount: extra ? 2 : 1,
                    hint: "Make it sparkle!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.cupcakeBase, .cupcakeFrosting, .sprinkles]
        )
    }

    private static func hotDog(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .hotDog,
            type: .hotDog,
            title: FoodType.hotDog.taskTitle,
            ingredients: [
                Ingredient(id: .hotdogBun),
                Ingredient(id: .sausage),
                Ingredient(id: .mustard),
                Ingredient(id: .ketchup),
                Ingredient(id: .onion, isOptional: extra)
            ],
            steps: [
                GameStep(id: "bun", accepted: [.hotdogBun], hint: "Open the bun!"),
                GameStep(id: "dog", accepted: [.sausage], hint: "Dog in the bun!"),
                GameStep(
                    id: "sauce",
                    accepted: extra ? [.mustard, .ketchup, .onion] : [.mustard, .ketchup],
                    minCount: 1,
                    hint: "Squiggle a sauce!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.hotdogBun, .sausage, .mustard]
        )
    }

    private static func pancakes(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .pancakes,
            type: .pancakes,
            title: FoodType.pancakes.taskTitle,
            ingredients: [
                Ingredient(id: .bread),
                Ingredient(id: .vanilla),
                Ingredient(id: .strawberry),
                Ingredient(id: .cherry, isOptional: true)
            ],
            steps: [
                GameStep(id: "stack", accepted: [.bread], hint: "Pancake first!"),
                GameStep(id: "cream", accepted: [.vanilla], hint: "A creamy swirl!"),
                GameStep(
                    id: "fruit",
                    accepted: extra ? [.strawberry, .cherry] : [.strawberry],
                    minCount: 1,
                    hint: "Add fruit!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.bread, .vanilla, .strawberry]
        )
    }

    private static func salad(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .lettuce),
            Ingredient(id: .tomato),
            Ingredient(id: .avocado),
            Ingredient(id: .cheese)
        ]
        if extra { tray.append(Ingredient(id: .onion, isOptional: true)) }
        return FoodGameDefinition(
            id: .salad,
            type: .salad,
            title: FoodType.salad.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "greens", accepted: [.lettuce], hint: "Start with greens!"),
                GameStep(id: "veg", accepted: extra ? [.tomato, .avocado, .onion] : [.tomato, .avocado], minCount: 1, hint: "Add veggies!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Cheesy finish!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.lettuce, .tomato, .avocado, .cheese]
        )
    }

    private static func smoothie(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .smoothie,
            type: .smoothie,
            title: FoodType.smoothie.taskTitle,
            ingredients: [
                Ingredient(id: .strawberry),
                Ingredient(id: .vanilla),
                Ingredient(id: .mint),
                Ingredient(id: .cherry, isOptional: true)
            ],
            steps: [
                GameStep(id: "fruit", accepted: [.strawberry], hint: "Berries first!"),
                GameStep(id: "cream", accepted: [.vanilla], hint: "Make it creamy!"),
                GameStep(
                    id: "fresh",
                    accepted: extra ? [.mint, .cherry] : [.mint],
                    minCount: 1,
                    hint: "A fresh finish!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.strawberry, .vanilla, .mint]
        )
    }

    private static func cookies(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .cookies,
            type: .cookies,
            title: FoodType.cookies.taskTitle,
            ingredients: [
                Ingredient(id: .dough),
                Ingredient(id: .chocolate),
                Ingredient(id: .sprinkles),
                Ingredient(id: .cherry, isOptional: extra)
            ],
            steps: [
                GameStep(id: "dough", accepted: [.dough], hint: "Soft cookie dough!"),
                GameStep(id: "chips", accepted: [.chocolate], hint: "Chocolate chips!"),
                GameStep(
                    id: "fun",
                    accepted: extra ? [.sprinkles, .cherry] : [.sprinkles],
                    minCount: 1,
                    hint: "Make them fun!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.dough, .chocolate, .sprinkles]
        )
    }
}
