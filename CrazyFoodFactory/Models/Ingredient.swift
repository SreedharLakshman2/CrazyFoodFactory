import SwiftUI

enum IngredientGroup: String, CaseIterable, Identifiable {
    case veggies
    case fruits
    case grains
    case dairy
    case proteins
    case sauces
    case treats

    var id: String { rawValue }

    var title: String {
        switch self {
        case .veggies: return "Veggies"
        case .fruits: return "Fruits"
        case .grains: return "Breads & Grains"
        case .dairy: return "Dairy"
        case .proteins: return "Proteins"
        case .sauces: return "Sauces & Dips"
        case .treats: return "Sweet Bits"
        }
    }

    var tint: Color {
        switch self {
        case .veggies: return Color(hex: 0x7EE08A)
        case .fruits: return Color(hex: 0xFF8A6A)
        case .grains: return Color(hex: 0xF4C56A)
        case .dairy: return Color(hex: 0xFFE14A)
        case .proteins: return Color(hex: 0xC4783A)
        case .sauces: return Color(hex: 0xFF6B5A)
        case .treats: return Color(hex: 0xFF8AD4)
        }
    }
}

enum IngredientID: String, Codable, CaseIterable, Identifiable, Hashable {
    case dough
    case tomatoSauce
    case cheese
    case pepperoni
    case greenPepper
    case mushroom
    case pineapple
    case bun
    case patty
    case lettuce
    case tomato
    case onion
    case topBun
    case cone
    case vanilla
    case strawberry
    case chocolate
    case mint
    case scoop
    case sprinkles
    case cherry
    case donutBase
    case chocolateFrosting
    case strawberryFrosting
    case vanillaFrosting
    case rainbowCandy
    case bread
    case ham
    case topBread
    case tortilla
    case tacoBeef
    case salsa
    case avocado
    case noodles
    case meatball
    case basil
    case cupcakeBase
    case cupcakeFrosting
    case candle
    case sausage
    case hotdogBun
    case mustard
    case ketchup
    case potato
    case rice
    case paneer
    case mango
    case yogurt
    case coconut
    case coconutChutney
    case sambar
    case chickpeas
    case spinach
    case corn
    case lime
    case egg
    case nori
    case cucumber
    case chips
    case falafel
    case hummus
    case dosa
    case idli
    case vada
    case naan
    case cilantro

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dough: return "Dough"
        case .tomatoSauce: return "Sauce"
        case .cheese: return "Cheese"
        case .pepperoni: return "Pepperoni"
        case .greenPepper: return "Pepper"
        case .mushroom: return "Mushroom"
        case .pineapple: return "Pineapple"
        case .bun, .topBun: return "Bun"
        case .patty: return "Patty"
        case .lettuce: return "Lettuce"
        case .tomato: return "Tomato"
        case .onion: return "Onion"
        case .cone: return "Cone"
        case .vanilla: return "Vanilla"
        case .strawberry: return "Strawberry"
        case .chocolate: return "Chocolate"
        case .mint: return "Mint"
        case .scoop: return "Scoop"
        case .sprinkles: return "Sprinkles"
        case .cherry: return "Cherry"
        case .donutBase: return "Donut"
        case .chocolateFrosting: return "Chocolate"
        case .strawberryFrosting: return "Strawberry"
        case .vanillaFrosting: return "Vanilla"
        case .rainbowCandy: return "Rainbow"
        case .bread, .topBread: return "Bread"
        case .ham: return "Ham"
        case .tortilla: return "Tortilla"
        case .tacoBeef: return "Beef"
        case .salsa: return "Salsa"
        case .avocado: return "Avocado"
        case .noodles: return "Noodles"
        case .meatball: return "Meatball"
        case .basil: return "Basil"
        case .cupcakeBase: return "Cake"
        case .cupcakeFrosting: return "Frosting"
        case .candle: return "Candle"
        case .sausage: return "Sausage"
        case .hotdogBun: return "Bun"
        case .mustard: return "Mustard"
        case .ketchup: return "Ketchup"
        case .potato: return "Potato"
        case .rice: return "Rice"
        case .paneer: return "Paneer"
        case .mango: return "Mango"
        case .yogurt: return "Yogurt"
        case .coconut: return "Coconut"
        case .coconutChutney: return "Chutney"
        case .sambar: return "Sambar"
        case .chickpeas: return "Chickpeas"
        case .spinach: return "Spinach"
        case .corn: return "Corn"
        case .lime: return "Lime"
        case .egg: return "Egg"
        case .nori: return "Nori"
        case .cucumber: return "Cucumber"
        case .chips: return "Chips"
        case .falafel: return "Falafel"
        case .hummus: return "Hummus"
        case .dosa: return "Dosa"
        case .idli: return "Idli"
        case .vada: return "Vada"
        case .naan: return "Naan"
        case .cilantro: return "Cilantro"
        }
    }

    var kidFact: String {
        switch self {
        case .dough: return "Soft flour mix that bakes into crust."
        case .tomatoSauce, .tomato: return "Tomatoes are juicy fruits used like veggies."
        case .cheese: return "Cheese is made from milk and is full of calcium."
        case .pepperoni: return "A spicy sausage slice for pizza."
        case .greenPepper: return "Crunchy sweet peppers are full of vitamin C."
        case .mushroom: return "Mushrooms grow in the dark, not on trees."
        case .pineapple: return "A sweet tropical fruit with a spiky coat."
        case .bun, .topBun, .hotdogBun: return "A soft bread bun holds the sandwich."
        case .patty: return "A cooked meat or bean cake."
        case .lettuce: return "Crunchy green leaves full of water."
        case .onion: return "Onions can make eyes water, but they are tasty."
        case .cone: return "A crunchy wafer cup for ice cream."
        case .vanilla: return "Vanilla comes from a climbing orchid."
        case .strawberry: return "Strawberries wear their seeds on the outside."
        case .chocolate: return "Chocolate starts as cacao beans."
        case .mint: return "Mint leaves smell cool and fresh."
        case .scoop: return "A round ball of ice cream."
        case .sprinkles, .rainbowCandy: return "Tiny sugar bits that make food extra fun."
        case .cherry: return "A small sweet fruit with a pit inside."
        case .donutBase: return "A fried dough ring ready for frosting."
        case .chocolateFrosting, .strawberryFrosting, .vanillaFrosting, .cupcakeFrosting:
            return "Sweet, creamy topping kids love to swirl."
        case .bread, .topBread: return "Bread is baked from flour, water, and yeast."
        case .ham: return "A savory sliced meat for stacking."
        case .tortilla: return "A flat corn or flour wrap from Mexico."
        case .tacoBeef: return "Seasoned cooked beef for tacos."
        case .salsa: return "A chunky tomato dip that can be mild or spicy."
        case .avocado: return "A creamy green fruit full of healthy fats."
        case .noodles: return "Long pasta made from wheat and water."
        case .meatball: return "A round ball of seasoned meat."
        case .basil: return "A sweet-smelling green herb."
        case .cupcakeBase: return "A little cake baked in a paper cup."
        case .candle: return "A tiny light for a birthday treat."
        case .sausage: return "A seasoned meat cooked in a long shape."
        case .mustard: return "A tangy yellow sauce from mustard seeds."
        case .ketchup: return "A sweet tomato sauce for dipping."
        case .potato: return "Potatoes grow underground and mash up fluffy."
        case .rice: return "Tiny grains that puff up soft when steamed."
        case .paneer: return "A mild Indian cheese that stays in cubes when cooked."
        case .mango: return "A juicy golden fruit that smells like sunshine."
        case .yogurt: return "Creamy milk that tiny helpers called cultures make thick."
        case .coconut: return "A giant seed with sweet white inside and water in the middle."
        case .coconutChutney: return "A cool coconut dip for dosa, idli, and vada."
        case .sambar: return "A warm lentil veggie stew from South India."
        case .chickpeas: return "Little round beans that make hummus, chole, and falafel."
        case .spinach: return "Leafy greens that cook down extra soft and green."
        case .corn: return "Sunny yellow kernels that grow on a cob."
        case .lime: return "A tiny sour green citrus that wakes up flavors."
        case .egg: return "Eggs can be fried, boiled, or dropped into ramen."
        case .nori: return "Crispy dried seaweed sheets that wrap sushi."
        case .cucumber: return "A cool crunchy veggie that is mostly water."
        case .chips: return "Crispy baked or fried triangles for scooping dips."
        case .falafel: return "Crunchy fried balls made from mashed chickpeas."
        case .hummus: return "A smooth chickpea dip you scoop with bread."
        case .dosa: return "A thin crispy crepe made from rice and lentil batter."
        case .idli: return "Soft steamed rice cakes, like little savory clouds."
        case .vada: return "A crunchy savory donut made from lentils."
        case .naan: return "A puffy oven bread with toasty brown spots."
        case .cilantro: return "A fresh leafy herb that smells bright and lemony."
        }
    }

    var kidFactShort: String {
        switch self {
        case .dough: return "Soft mix that bakes into crust"
        case .tomatoSauce, .tomato: return "Juicy fruit, used like a veggie"
        case .cheese: return "Made from milk. Calcium!"
        case .pepperoni: return "Spicy sausage pizza slice"
        case .greenPepper: return "Crunchy and full of vitamin C"
        case .mushroom: return "Grows in the dark, yummy"
        case .pineapple: return "Sweet fruit with a spiky coat"
        case .bun, .topBun, .hotdogBun: return "Soft bread that holds lunch"
        case .patty: return "A cooked meat or bean cake"
        case .lettuce: return "Crunchy green water-leaves"
        case .onion: return "Tasty, can make eyes water"
        case .cone: return "Crunchy cup for ice cream"
        case .vanilla: return "Comes from a climbing orchid"
        case .strawberry: return "Seeds live on the outside"
        case .chocolate: return "Starts as cacao beans"
        case .mint: return "Leaves that smell cool"
        case .scoop: return "A round ice-cream ball"
        case .sprinkles, .rainbowCandy: return "Tiny sugar bits. Extra fun!"
        case .cherry: return "Small sweet fruit with a pit"
        case .donutBase: return "A fried dough ring"
        case .chocolateFrosting, .strawberryFrosting, .vanillaFrosting, .cupcakeFrosting:
            return "Sweet swirl kids love"
        case .bread, .topBread: return "Baked from flour and yeast"
        case .ham: return "Savory slice for stacking"
        case .tortilla: return "Flat wrap from Mexico"
        case .tacoBeef: return "Seasoned taco meat"
        case .salsa: return "Chunky tomato dip"
        case .avocado: return "Creamy green fruit"
        case .noodles: return "Long pasta from wheat"
        case .meatball: return "A round seasoned meat ball"
        case .basil: return "Sweet-smelling green herb"
        case .cupcakeBase: return "A little cake in a paper cup"
        case .candle: return "Tiny light for a birthday"
        case .sausage: return "Long seasoned cooked meat"
        case .mustard: return "Tangy yellow seed sauce"
        case .ketchup: return "Sweet tomato dipping sauce"
        case .potato: return "Grows underground. Mashes fluffy"
        case .rice: return "Tiny grains that steam up soft"
        case .paneer: return "Mild cheese that stays in cubes"
        case .mango: return "Golden fruit that smells sunny"
        case .yogurt: return "Thick creamy cultured milk"
        case .coconut: return "Giant seed with sweet white inside"
        case .coconutChutney: return "Cool coconut dip for dosa"
        case .sambar: return "Warm South Indian lentil stew"
        case .chickpeas: return "Little round beans. Super handy!"
        case .spinach: return "Leafy greens that cook extra soft"
        case .corn: return "Sunny kernels on a cob"
        case .lime: return "Tiny sour citrus. Flavor wake-up!"
        case .egg: return "Fry it, boil it, drop it in ramen"
        case .nori: return "Crispy seaweed that wraps sushi"
        case .cucumber: return "Cool crunch. Mostly water!"
        case .chips: return "Crispy triangles for scooping"
        case .falafel: return "Crunchy chickpea balls"
        case .hummus: return "Smooth chickpea dip"
        case .dosa: return "Thin crispy rice-and-lentil crepe"
        case .idli: return "Soft steamed rice cakes"
        case .vada: return "Crunchy savory lentil donut"
        case .naan: return "Puffy bread with toasty spots"
        case .cilantro: return "Bright lemony cooking leaves"
        }
    }

    var cookingUse: String {
        switch self {
        case .dough: return "Chefs press it into pizza crust and cookies."
        case .tomatoSauce: return "Spoon it on pizza and pasta."
        case .cheese: return "Melt it on pizza, nachos, and quesadillas."
        case .pepperoni: return "Lay the circles on pizza."
        case .greenPepper: return "Chop it for pizza, tikka, and ramen."
        case .mushroom: return "Slice it onto pizza."
        case .pineapple: return "A wild pizza topping — some chefs say yes!"
        case .bun, .topBun, .hotdogBun: return "It hugs burgers and hot dogs."
        case .patty: return "The tasty middle of a burger."
        case .lettuce: return "Stack it on burgers, tacos, and wraps."
        case .tomato: return "Slice it for sandwiches, sambar, and salsa."
        case .onion: return "Cook it into sambar, biryani, and guacamole."
        case .cone: return "Hold ice cream so it does not drip on you."
        case .vanilla: return "Scoop it, swirl it, or blend it into drinks."
        case .strawberry: return "Pop it on pancakes, smoothies, and sundaes."
        case .chocolate: return "Chips for cookies, scoops for sundaes."
        case .mint: return "A fresh finish for lassi, biryani, and smoothies."
        case .scoop: return "Pile scoops on a cone."
        case .sprinkles, .rainbowCandy: return "Rain them on donuts, cupcakes, and cookies."
        case .cherry: return "The tiny hat on ice cream and cupcakes."
        case .donutBase: return "Frost it and add sprinkles."
        case .chocolateFrosting, .strawberryFrosting, .vanillaFrosting, .cupcakeFrosting:
            return "Swirl it on donuts and cupcakes."
        case .bread, .topBread: return "The outside of a sandwich stack."
        case .ham: return "Layer it in sandwiches."
        case .tortilla: return "Fold it for tacos, burritos, and quesadillas."
        case .tacoBeef: return "Fill tacos and burritos."
        case .salsa: return "Spoon it on tacos, nachos, and elote."
        case .avocado: return "Mash guacamole or tuck it into sushi."
        case .noodles: return "Twirl pasta or slurp ramen."
        case .meatball: return "Nestle it in pasta."
        case .basil: return "Tear it over pasta."
        case .cupcakeBase: return "Frost the little cake."
        case .candle: return "Stick it in a birthday cupcake."
        case .sausage: return "Tuck it in a hot-dog bun."
        case .mustard: return "Squiggle it on hot dogs."
        case .ketchup: return "Dip fries or squiggle hot dogs."
        case .potato: return "Mash it inside dosa or drop it in sambar."
        case .rice: return "Fluff it for biryani, sushi, and burritos."
        case .paneer: return "Grill tikka, tuck wraps, or swim in palak."
        case .mango: return "Blend it into mango lassi."
        case .yogurt: return "Blend lassi, drizzle wraps, or cool palak."
        case .coconut: return "Grind it into chutney for dosa and idli."
        case .coconutChutney: return "Dip dosa, idli, and vada."
        case .sambar: return "Pour it beside idli, vada, and dosa."
        case .chickpeas: return "Simmer chole, mash hummus, or fry falafel."
        case .spinach: return "Stir it into palak or drop it in ramen."
        case .corn: return "Dress it as elote or sprinkle on nachos."
        case .lime: return "Squeeze it on guacamole, elote, and salsa."
        case .egg: return "Halve it on ramen."
        case .nori: return "Wrap sushi rolls."
        case .cucumber: return "Tuck it in sushi or dunk it in hummus."
        case .chips: return "Pile nachos or scoop guacamole."
        case .falafel: return "Stuff pita with the crunchy balls."
        case .hummus: return "Spread it, scoop it, dunk veggies in it."
        case .dosa: return "Fill the crispy crepe with potato."
        case .idli: return "Dunk the steamed cakes in sambar."
        case .vada: return "Dip the crunchy ring in chutney."
        case .naan: return "Wrap fillings or scoop up chole."
        case .cilantro: return "Sprinkle it on chole, nachos, and salsa."
        }
    }

    var learnLine: String { "\(displayName)! \(kidFact)" }

    var schoolLesson: String {
        "\(displayName)! \(kidFact) \(cookingUse)"
    }

    var schoolGroup: IngredientGroup {
        switch self {
        case .lettuce, .tomato, .onion, .greenPepper, .mushroom, .avocado, .potato,
             .spinach, .cucumber, .corn, .basil, .cilantro:
            return .veggies
        case .pineapple, .strawberry, .cherry, .mango, .lime, .coconut:
            return .fruits
        case .dough, .bun, .topBun, .hotdogBun, .bread, .topBread, .tortilla, .noodles,
             .rice, .chips, .dosa, .idli, .vada, .naan, .cone, .donutBase, .cupcakeBase, .nori:
            return .grains
        case .cheese, .vanilla, .scoop, .yogurt, .paneer, .vanillaFrosting:
            return .dairy
        case .patty, .ham, .tacoBeef, .meatball, .sausage, .pepperoni, .egg, .chickpeas, .falafel:
            return .proteins
        case .tomatoSauce, .salsa, .mustard, .ketchup, .coconutChutney, .sambar, .hummus,
             .chocolateFrosting, .strawberryFrosting, .cupcakeFrosting:
            return .sauces
        case .sprinkles, .rainbowCandy, .chocolate, .mint, .candle:
            return .treats
        }
    }

    /// Unique roster for Ingredient School (skips stack twins like top bun).
    static var schoolRoster: [IngredientID] {
        [
            .tomato, .lettuce, .onion, .greenPepper, .mushroom, .avocado, .potato,
            .spinach, .cucumber, .corn, .basil, .cilantro,
            .pineapple, .strawberry, .cherry, .mango, .lime, .coconut,
            .dough, .bread, .bun, .tortilla, .naan, .noodles, .rice, .chips,
            .dosa, .idli, .vada, .nori, .cone,
            .cheese, .yogurt, .paneer, .vanilla,
            .patty, .ham, .tacoBeef, .egg, .chickpeas, .falafel, .sausage, .meatball,
            .tomatoSauce, .salsa, .mustard, .ketchup, .coconutChutney, .sambar, .hummus,
            .sprinkles, .chocolate, .mint
        ]
    }

    var trayColor: Color {
        switch self {
        case .dough, .bun, .topBun, .bread, .topBread, .cone, .tortilla, .hotdogBun, .noodles,
             .cupcakeBase, .rice, .naan, .dosa, .idli, .chips:
            return Color(hex: 0xF4C56A)
        case .tomatoSauce, .tomato, .pepperoni, .cherry, .salsa, .ketchup, .sambar:
            return Color(hex: 0xFF6B5A)
        case .cheese, .corn, .chickpeas, .hummus: return Color(hex: 0xFFE14A)
        case .greenPepper, .spinach, .nori: return Color(hex: 0x7EE08A)
        case .mushroom, .onion, .potato, .vada, .falafel: return Color(hex: 0xE8D7C3)
        case .pineapple, .mango, .lime: return Color(hex: 0xFFE36B)
        case .patty, .chocolate, .chocolateFrosting, .ham, .tacoBeef, .meatball, .sausage:
            return Color(hex: 0xC4783A)
        case .lettuce, .avocado, .basil, .cilantro, .cucumber, .coconutChutney:
            return Color(hex: 0x7EE08A)
        case .vanilla, .vanillaFrosting, .scoop, .yogurt, .paneer, .coconut, .egg:
            return Color(hex: 0xFFF4C8)
        case .strawberry, .strawberryFrosting, .cupcakeFrosting: return Color(hex: 0xFF9BC8)
        case .mint: return Color(hex: 0x8EF0C2)
        case .sprinkles, .rainbowCandy: return Color(hex: 0xFF8AD4)
        case .donutBase: return Color(hex: 0xE8B56A)
        case .candle: return Color(hex: 0xFFD36A)
        case .mustard: return Color(hex: 0xFFE14A)
        }
    }
}

struct Ingredient: Identifiable, Hashable {
    let id: IngredientID
    var isChaosBait: Bool = false
    var isOptional: Bool = false

    var displayName: String { id.displayName }
    var kidFact: String { id.kidFact }
    var kidFactShort: String { id.kidFactShort }
    var cookingUse: String { id.cookingUse }
    var trayColor: Color { id.trayColor }
}
