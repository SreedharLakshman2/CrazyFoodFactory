import SwiftUI

enum FoodType: String, Codable, CaseIterable, Identifiable, Hashable {
    case pizza
    case burger
    case iceCream
    case donut
    case sandwich

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pizza: return "Pizza"
        case .burger: return "Burger"
        case .iceCream: return "Ice Cream"
        case .donut: return "Donuts"
        case .sandwich: return "Sandwich"
        }
    }

    var taskTitle: String {
        switch self {
        case .pizza: return "Make a Pizza!"
        case .burger: return "Make a Burger!"
        case .iceCream: return "Make Ice Cream!"
        case .donut: return "Decorate Donuts!"
        case .sandwich: return "Build the Perfect Sandwich!"
        }
    }

    var resultTitle: String {
        switch self {
        case .pizza: return "Pizza Ready!"
        case .burger: return "Burger Done!"
        case .iceCream: return "Ice Cream Ready!"
        case .donut: return "Donut Decorated!"
        case .sandwich: return "Sandwich Complete!"
        }
    }

    var cardColor: Color {
        switch self {
        case .pizza: return Color.white
        case .burger: return Color(hex: 0xFFE7A8)
        case .iceCream: return Color(hex: 0xE8D6FF)
        case .donut: return Color(hex: 0xFFD2EC)
        case .sandwich: return Color(hex: 0xC4F5C0)
        }
    }

    var accent: Color {
        switch self {
        case .pizza: return GameTheme.pizzaRed
        case .burger: return GameTheme.burgerOrange
        case .iceCream: return GameTheme.iceCreamPink
        case .donut: return GameTheme.donutPink
        case .sandwich: return GameTheme.sandwichGreen
        }
    }

    var speechHint: String {
        switch self {
        case .pizza: return "Add the right ingredients!"
        case .burger: return "Stack it yummy!"
        case .iceCream: return "Scoop, don't bake!"
        case .donut: return "Tap to add toppings!"
        case .sandwich: return "Stack the layers correctly!"
        }
    }
}

enum FoodAsset {
    case pizza
    case burger
    case iceCream
    case donut
    case sandwich

    init(food: FoodType) {
        switch food {
        case .pizza: self = .pizza
        case .burger: self = .burger
        case .iceCream: self = .iceCream
        case .donut: self = .donut
        case .sandwich: self = .sandwich
        }
    }
}
