import SwiftUI

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
        }
    }

    var learnLine: String { "\(displayName)! \(kidFact)" }

    var trayColor: Color {
        switch self {
        case .dough, .bun, .topBun, .bread, .topBread, .cone, .tortilla, .hotdogBun, .noodles, .cupcakeBase:
            return Color(hex: 0xF4C56A)
        case .tomatoSauce, .tomato, .pepperoni, .cherry, .salsa, .ketchup:
            return Color(hex: 0xFF6B5A)
        case .cheese: return Color(hex: 0xFFE14A)
        case .greenPepper: return Color(hex: 0x7EE08A)
        case .mushroom, .onion: return Color(hex: 0xE8D7C3)
        case .pineapple: return Color(hex: 0xFFE36B)
        case .patty, .chocolate, .chocolateFrosting, .ham, .tacoBeef, .meatball, .sausage:
            return Color(hex: 0xC4783A)
        case .lettuce, .avocado, .basil: return Color(hex: 0x7EE08A)
        case .vanilla, .vanillaFrosting, .scoop: return Color(hex: 0xFFF4C8)
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
    var trayColor: Color { id.trayColor }
}
