import SwiftUI

enum IngredientID: String, Codable, CaseIterable, Identifiable, Hashable {
    case dough
    case tomatoSauce
    case cheese
    case pepperoni
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

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dough: return "Dough"
        case .tomatoSauce: return "Tomato"
        case .cheese: return "Cheese"
        case .pepperoni: return "Pepperoni"
        case .mushroom: return "Mushroom"
        case .pineapple: return "Pineapple"
        case .bun: return "Bun"
        case .patty: return "Patty"
        case .lettuce: return "Lettuce"
        case .tomato: return "Tomato"
        case .onion: return "Onion"
        case .topBun: return "Top Bun"
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
        case .bread: return "Bread"
        case .ham: return "Ham"
        case .topBread: return "Bread"
        }
    }

    var trayColor: Color {
        switch self {
        case .dough, .bun, .topBun, .bread, .topBread, .cone: return Color(hex: 0xF4C56A)
        case .tomatoSauce, .tomato, .pepperoni, .cherry: return Color(hex: 0xFF6B5A)
        case .cheese: return Color(hex: 0xFFE14A)
        case .mushroom, .onion: return Color(hex: 0xE8D7C3)
        case .pineapple: return Color(hex: 0xFFE36B)
        case .patty, .chocolate, .chocolateFrosting, .ham: return Color(hex: 0xC4783A)
        case .lettuce: return Color(hex: 0x7EE08A)
        case .vanilla, .vanillaFrosting, .scoop: return Color(hex: 0xFFF4C8)
        case .strawberry, .strawberryFrosting: return Color(hex: 0xFF9BC8)
        case .mint: return Color(hex: 0x8EF0C2)
        case .sprinkles, .rainbowCandy: return Color(hex: 0xFF8AD4)
        case .donutBase: return Color(hex: 0xE8B56A)
        }
    }
}

struct Ingredient: Identifiable, Hashable {
    let id: IngredientID
    var isChaosBait: Bool = false
    var isOptional: Bool = false

    var displayName: String { id.displayName }
    var trayColor: Color { id.trayColor }
}
