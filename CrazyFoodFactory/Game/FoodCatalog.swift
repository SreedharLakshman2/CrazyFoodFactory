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
        case .dosa: return dosa(extra: extra)
        case .idli: return idli(extra: extra)
        case .sambar: return sambar(extra: extra)
        case .vada: return vada(extra: extra)
        case .biryani: return biryani(extra: extra)
        case .paneerTikka: return paneerTikka(extra: extra)
        case .naanWrap: return naanWrap(extra: extra)
        case .chole: return chole(extra: extra)
        case .palak: return palak(extra: extra)
        case .mangoLassi: return mangoLassi(extra: extra)
        case .nachos: return nachos(extra: extra)
        case .quesadilla: return quesadilla(extra: extra)
        case .burrito: return burrito(extra: extra)
        case .guacamole: return guacamole(extra: extra)
        case .elote: return elote(extra: extra)
        case .ramen: return ramen(extra: extra)
        case .sushiRoll: return sushiRoll(extra: extra)
        case .falafel: return falafel(extra: extra)
        case .hummus: return hummus(extra: extra)
        }
    }

    static func foods(using ingredient: IngredientID) -> [FoodType] {
        let probe = LevelDefinition(
            id: 99,
            title: "Learn",
            requiredFoods: FoodType.allCases,
            chaosChance: 0,
            extraIngredients: true
        )
        return FoodType.allCases.filter { food in
            let def = definition(for: food, level: probe)
            return def.ingredients.contains(where: { $0.id == ingredient })
                || def.prePlaced.contains(ingredient)
                || def.checklist.contains(ingredient)
                || def.steps.contains(where: { $0.accepted.contains(ingredient) })
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
                GameStep(
                    id: "scoops",
                    accepted: extra ? [.vanilla, .strawberry, .chocolate, .mint] : [.vanilla, .strawberry, .chocolate],
                    minCount: 2,
                    hint: "Two yummy scoops!"
                ),
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
                Ingredient(id: .cherry, isOptional: true)
            ],
            steps: [
                GameStep(
                    id: "frosting",
                    accepted: [.chocolateFrosting, .strawberryFrosting, .vanillaFrosting],
                    hint: "Pick a frosting!"
                ),
                GameStep(
                    id: "toppings",
                    accepted: extra ? [.sprinkles, .cherry] : [.sprinkles, .cherry],
                    minCount: 1,
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

    private static func dosa(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .dosa),
            Ingredient(id: .potato),
            Ingredient(id: .coconutChutney),
            Ingredient(id: .sambar)
        ]
        if extra { tray.append(Ingredient(id: .coconut, isOptional: true)) }
        tray.append(Ingredient(id: .pineapple, isChaosBait: true, isOptional: true))
        return FoodGameDefinition(
            id: .dosa,
            type: .dosa,
            title: FoodType.dosa.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "crepe", accepted: [.dosa], hint: "Crispy crepe first!"),
                GameStep(id: "fill", accepted: [.potato], hint: "Fluffy potato filling!"),
                GameStep(
                    id: "dip",
                    accepted: extra ? [.coconutChutney, .sambar, .coconut] : [.coconutChutney, .sambar],
                    minCount: extra ? 2 : 1,
                    chaosIngredients: [.pineapple],
                    hint: "Dip in chutney!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.dosa, .potato, .coconutChutney]
        )
    }

    private static func idli(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .idli),
            Ingredient(id: .coconutChutney),
            Ingredient(id: .sambar)
        ]
        if extra { tray.append(Ingredient(id: .coconut, isOptional: true)) }
        return FoodGameDefinition(
            id: .idli,
            type: .idli,
            title: FoodType.idli.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "cake", accepted: [.idli], hint: "Soft idli first!"),
                GameStep(id: "chutney", accepted: extra ? [.coconutChutney, .coconut] : [.coconutChutney], hint: "Cool coconut dip!"),
                GameStep(id: "stew", accepted: [.sambar], hint: "Warm sambar splash!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.idli, .coconutChutney, .sambar]
        )
    }

    private static func sambar(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .sambar),
            Ingredient(id: .tomato),
            Ingredient(id: .onion),
            Ingredient(id: .potato)
        ]
        if extra { tray.append(Ingredient(id: .spinach, isOptional: true)) }
        return FoodGameDefinition(
            id: .sambar,
            type: .sambar,
            title: FoodType.sambar.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "stew", accepted: [.sambar], hint: "Start the stew!"),
                GameStep(id: "tomato", accepted: [.tomato], hint: "Juicy tomato!"),
                GameStep(
                    id: "veg",
                    accepted: extra ? [.onion, .potato, .spinach] : [.onion, .potato],
                    minCount: extra ? 2 : 1,
                    hint: "Add veggies!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.sambar, .tomato, .onion]
        )
    }

    private static func vada(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .vada),
            Ingredient(id: .coconutChutney),
            Ingredient(id: .sambar)
        ]
        if extra { tray.append(Ingredient(id: .onion, isOptional: true)) }
        return FoodGameDefinition(
            id: .vada,
            type: .vada,
            title: FoodType.vada.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "ring", accepted: [.vada], hint: "Crunchy ring first!"),
                GameStep(id: "dip", accepted: extra ? [.coconutChutney, .onion] : [.coconutChutney], hint: "Chutney dip!"),
                GameStep(id: "stew", accepted: [.sambar], hint: "Sambar splash!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.vada, .coconutChutney, .sambar]
        )
    }

    private static func biryani(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .rice),
            Ingredient(id: .paneer),
            Ingredient(id: .onion),
            Ingredient(id: .mint)
        ]
        if extra { tray.append(Ingredient(id: .cilantro, isOptional: true)) }
        tray.append(Ingredient(id: .pineapple, isChaosBait: true, isOptional: true))
        return FoodGameDefinition(
            id: .biryani,
            type: .biryani,
            title: FoodType.biryani.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "rice", accepted: [.rice], hint: "Fluffy rice first!"),
                GameStep(id: "paneer", accepted: [.paneer], hint: "Paneer cubes!"),
                GameStep(
                    id: "top",
                    accepted: extra ? [.onion, .mint, .cilantro] : [.onion, .mint],
                    minCount: extra ? 2 : 1,
                    chaosIngredients: [.pineapple],
                    hint: "Onion and mint!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.rice, .paneer, .onion, .mint]
        )
    }

    private static func paneerTikka(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .paneer),
            Ingredient(id: .greenPepper),
            Ingredient(id: .onion),
            Ingredient(id: .tomato)
        ]
        if extra { tray.append(Ingredient(id: .mint, isOptional: true)) }
        return FoodGameDefinition(
            id: .paneerTikka,
            type: .paneerTikka,
            title: FoodType.paneerTikka.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "cheese", accepted: [.paneer], hint: "Paneer first!"),
                GameStep(id: "pepper", accepted: [.greenPepper], hint: "Crunchy pepper!"),
                GameStep(
                    id: "veg",
                    accepted: extra ? [.onion, .tomato, .mint] : [.onion, .tomato],
                    minCount: extra ? 2 : 1,
                    hint: "Onion and tomato!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.paneer, .greenPepper, .onion]
        )
    }

    private static func naanWrap(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .naan),
            Ingredient(id: .paneer),
            Ingredient(id: .lettuce),
            Ingredient(id: .yogurt)
        ]
        if extra { tray.append(Ingredient(id: .onion, isOptional: true)) }
        return FoodGameDefinition(
            id: .naanWrap,
            type: .naanWrap,
            title: FoodType.naanWrap.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "bread", accepted: [.naan], hint: "Warm naan first!"),
                GameStep(id: "paneer", accepted: [.paneer], hint: "Tuck in paneer!"),
                GameStep(id: "veg", accepted: extra ? [.lettuce, .onion] : [.lettuce], hint: "Crunchy greens!"),
                GameStep(id: "cool", accepted: [.yogurt], hint: "Cool yogurt drizzle!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.naan, .paneer, .lettuce]
        )
    }

    private static func chole(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .chickpeas),
            Ingredient(id: .tomato),
            Ingredient(id: .onion),
            Ingredient(id: .naan)
        ]
        if extra { tray.append(Ingredient(id: .cilantro, isOptional: true)) }
        return FoodGameDefinition(
            id: .chole,
            type: .chole,
            title: FoodType.chole.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "beans", accepted: [.chickpeas], hint: "Chickpeas first!"),
                GameStep(id: "tomato", accepted: [.tomato], hint: "Tomato splash!"),
                GameStep(id: "onion", accepted: extra ? [.onion, .cilantro] : [.onion], hint: "Onion mix!"),
                GameStep(id: "scoop", accepted: [.naan], hint: "Scoop with naan!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.chickpeas, .tomato, .naan]
        )
    }

    private static func palak(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .spinach),
            Ingredient(id: .paneer),
            Ingredient(id: .rice)
        ]
        if extra { tray.append(Ingredient(id: .yogurt, isOptional: true)) }
        return FoodGameDefinition(
            id: .palak,
            type: .palak,
            title: FoodType.palak.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "greens", accepted: [.spinach], hint: "Green spinach first!"),
                GameStep(id: "paneer", accepted: [.paneer], hint: "Paneer cubes!"),
                GameStep(
                    id: "side",
                    accepted: extra ? [.rice, .yogurt] : [.rice],
                    minCount: 1,
                    hint: "Rice on the side!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.spinach, .paneer, .rice]
        )
    }

    private static func mangoLassi(extra: Bool) -> FoodGameDefinition {
        FoodGameDefinition(
            id: .mangoLassi,
            type: .mangoLassi,
            title: FoodType.mangoLassi.taskTitle,
            ingredients: [
                Ingredient(id: .mango),
                Ingredient(id: .yogurt),
                Ingredient(id: .mint),
                Ingredient(id: .cherry, isOptional: true)
            ],
            steps: [
                GameStep(id: "mango", accepted: [.mango], hint: "Mango first!"),
                GameStep(id: "yogurt", accepted: [.yogurt], hint: "Make it creamy!"),
                GameStep(
                    id: "fresh",
                    accepted: extra ? [.mint, .cherry] : [.mint],
                    minCount: 1,
                    hint: "Minty finish!"
                )
            ],
            prePlaced: [],
            showsOven: true,
            ovenIsTrap: true,
            strictOrder: true,
            checklist: [.mango, .yogurt, .mint]
        )
    }

    private static func nachos(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .chips),
            Ingredient(id: .cheese),
            Ingredient(id: .salsa)
        ]
        if extra { tray.append(Ingredient(id: .avocado, isOptional: true)) }
        tray.append(Ingredient(id: .pineapple, isChaosBait: true, isOptional: true))
        return FoodGameDefinition(
            id: .nachos,
            type: .nachos,
            title: FoodType.nachos.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "chips", accepted: [.chips], hint: "Chips first!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Melted cheese!"),
                GameStep(
                    id: "top",
                    accepted: extra ? [.salsa, .avocado] : [.salsa],
                    minCount: 1,
                    chaosIngredients: [.pineapple],
                    hint: "Salsa splash!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.chips, .cheese, .salsa]
        )
    }

    private static func quesadilla(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .tortilla),
            Ingredient(id: .cheese),
            Ingredient(id: .tomato)
        ]
        if extra { tray.append(Ingredient(id: .salsa, isOptional: true)) }
        return FoodGameDefinition(
            id: .quesadilla,
            type: .quesadilla,
            title: FoodType.quesadilla.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "wrap", accepted: [.tortilla], hint: "Tortilla first!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Cheesy middle!"),
                GameStep(
                    id: "fill",
                    accepted: extra ? [.tomato, .salsa] : [.tomato],
                    minCount: 1,
                    hint: "Tomato bits!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.tortilla, .cheese, .tomato]
        )
    }

    private static func burrito(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .tortilla),
            Ingredient(id: .rice),
            Ingredient(id: .tacoBeef),
            Ingredient(id: .lettuce),
            Ingredient(id: .cheese)
        ]
        if extra { tray.append(Ingredient(id: .salsa, isOptional: true)) }
        return FoodGameDefinition(
            id: .burrito,
            type: .burrito,
            title: FoodType.burrito.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "wrap", accepted: [.tortilla], hint: "Open the wrap!"),
                GameStep(id: "rice", accepted: [.rice], hint: "Rice in the middle!"),
                GameStep(id: "beef", accepted: [.tacoBeef], hint: "Tasty filling!"),
                GameStep(
                    id: "top",
                    accepted: extra ? [.lettuce, .cheese, .salsa] : [.lettuce, .cheese],
                    minCount: extra ? 2 : 1,
                    hint: "Greens and cheese!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.tortilla, .rice, .tacoBeef, .lettuce]
        )
    }

    private static func guacamole(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .avocado),
            Ingredient(id: .tomato),
            Ingredient(id: .onion),
            Ingredient(id: .lime)
        ]
        if extra { tray.append(Ingredient(id: .chips, isOptional: true)) }
        return FoodGameDefinition(
            id: .guacamole,
            type: .guacamole,
            title: FoodType.guacamole.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "avo", accepted: [.avocado], hint: "Mash avocado!"),
                GameStep(id: "tomato", accepted: [.tomato], hint: "Tomato bits!"),
                GameStep(id: "onion", accepted: [.onion], hint: "Tiny onion!"),
                GameStep(
                    id: "finish",
                    accepted: extra ? [.lime, .chips] : [.lime],
                    minCount: 1,
                    hint: "Squeeze lime!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.avocado, .tomato, .lime]
        )
    }

    private static func elote(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .corn),
            Ingredient(id: .cheese),
            Ingredient(id: .lime)
        ]
        if extra { tray.append(Ingredient(id: .salsa, isOptional: true)) }
        return FoodGameDefinition(
            id: .elote,
            type: .elote,
            title: FoodType.elote.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "corn", accepted: [.corn], hint: "Corn on the cob!"),
                GameStep(id: "cheese", accepted: [.cheese], hint: "Cheesy sprinkle!"),
                GameStep(
                    id: "zest",
                    accepted: extra ? [.lime, .salsa] : [.lime],
                    minCount: 1,
                    hint: "Lime squeeze!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.corn, .cheese, .lime]
        )
    }

    private static func ramen(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .noodles),
            Ingredient(id: .egg),
            Ingredient(id: .onion)
        ]
        if extra { tray.append(Ingredient(id: .spinach, isOptional: true)) }
        return FoodGameDefinition(
            id: .ramen,
            type: .ramen,
            title: FoodType.ramen.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "noodles", accepted: [.noodles], hint: "Noodles in the bowl!"),
                GameStep(id: "egg", accepted: [.egg], hint: "Egg on top!"),
                GameStep(
                    id: "veg",
                    accepted: extra ? [.onion, .spinach] : [.onion],
                    minCount: 1,
                    hint: "Onion sprinkle!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.noodles, .egg, .onion]
        )
    }

    private static func sushiRoll(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .nori),
            Ingredient(id: .rice),
            Ingredient(id: .cucumber),
            Ingredient(id: .avocado)
        ]
        if extra { tray.append(Ingredient(id: .mango, isOptional: true)) }
        tray.append(Ingredient(id: .pineapple, isChaosBait: true, isOptional: true))
        return FoodGameDefinition(
            id: .sushiRoll,
            type: .sushiRoll,
            title: FoodType.sushiRoll.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "wrap", accepted: [.nori], hint: "Seaweed wrap first!"),
                GameStep(id: "rice", accepted: [.rice], hint: "Sticky rice!"),
                GameStep(
                    id: "fill",
                    accepted: extra ? [.cucumber, .avocado, .mango] : [.cucumber, .avocado],
                    minCount: extra ? 2 : 1,
                    chaosIngredients: [.pineapple],
                    hint: "Crunchy fillings!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.nori, .rice, .cucumber, .avocado]
        )
    }

    private static func falafel(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .naan),
            Ingredient(id: .falafel),
            Ingredient(id: .lettuce),
            Ingredient(id: .tomato)
        ]
        if extra { tray.append(Ingredient(id: .hummus, isOptional: true)) }
        return FoodGameDefinition(
            id: .falafel,
            type: .falafel,
            title: FoodType.falafel.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "pita", accepted: [.naan], hint: "Open the pita!"),
                GameStep(id: "balls", accepted: [.falafel], hint: "Crunchy falafel!"),
                GameStep(id: "veg", accepted: extra ? [.lettuce, .tomato, .hummus] : [.lettuce, .tomato], minCount: extra ? 2 : 1, hint: "Fresh veggies!")
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.naan, .falafel, .lettuce]
        )
    }

    private static func hummus(extra: Bool) -> FoodGameDefinition {
        var tray: [Ingredient] = [
            Ingredient(id: .hummus),
            Ingredient(id: .chickpeas),
            Ingredient(id: .naan)
        ]
        if extra { tray.append(Ingredient(id: .cucumber, isOptional: true)) }
        return FoodGameDefinition(
            id: .hummus,
            type: .hummus,
            title: FoodType.hummus.taskTitle,
            ingredients: tray,
            steps: [
                GameStep(id: "dip", accepted: [.hummus], hint: "Smooth hummus first!"),
                GameStep(id: "beans", accepted: [.chickpeas], hint: "Chickpea sprinkle!"),
                GameStep(
                    id: "dunk",
                    accepted: extra ? [.naan, .cucumber] : [.naan],
                    minCount: 1,
                    hint: "Dunk with naan!"
                )
            ],
            prePlaced: [],
            showsOven: false,
            ovenIsTrap: false,
            strictOrder: true,
            checklist: [.hummus, .chickpeas, .naan]
        )
    }
}
