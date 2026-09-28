import SwiftUI

enum FoodType: String, Codable, CaseIterable, Identifiable, Hashable {
    case pizza
    case burger
    case iceCream
    case donut
    case sandwich
    case taco
    case pasta
    case cupcake
    case hotDog
    case pancakes
    case salad
    case smoothie
    case cookies

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pizza: return "Pizza"
        case .burger: return "Burger"
        case .iceCream: return "Ice Cream"
        case .donut: return "Donuts"
        case .sandwich: return "Sandwich"
        case .taco: return "Taco"
        case .pasta: return "Pasta"
        case .cupcake: return "Cupcake"
        case .hotDog: return "Hot Dog"
        case .pancakes: return "Pancakes"
        case .salad: return "Salad"
        case .smoothie: return "Smoothie"
        case .cookies: return "Cookies"
        }
    }

    var taskTitle: String {
        switch self {
        case .pizza: return "Make a Pizza!"
        case .burger: return "Make a Burger!"
        case .iceCream: return "Make Ice Cream!"
        case .donut: return "Decorate Donuts!"
        case .sandwich: return "Build the Perfect Sandwich!"
        case .taco: return "Build a Taco!"
        case .pasta: return "Cook the Pasta!"
        case .cupcake: return "Frost a Cupcake!"
        case .hotDog: return "Make a Hot Dog!"
        case .pancakes: return "Stack the Pancakes!"
        case .salad: return "Toss a Fresh Salad!"
        case .smoothie: return "Blend a Smoothie!"
        case .cookies: return "Bake Cookies!"
        }
    }

    var resultTitle: String {
        switch self {
        case .pizza: return "Pizza Ready!"
        case .burger: return "Burger Done!"
        case .iceCream: return "Ice Cream Ready!"
        case .donut: return "Donut Decorated!"
        case .sandwich: return "Sandwich Complete!"
        case .taco: return "Taco Time!"
        case .pasta: return "Pasta Perfect!"
        case .cupcake: return "Cupcake Cute!"
        case .hotDog: return "Hot Dog Yum!"
        case .pancakes: return "Pancake Stack!"
        case .salad: return "Salad Fresh!"
        case .smoothie: return "Sip Sip Yay!"
        case .cookies: return "Cookie Time!"
        }
    }

    var cardColor: Color {
        switch self {
        case .pizza: return Color.white
        case .burger: return Color(hex: 0xFFE7A8)
        case .iceCream: return Color(hex: 0xE8D6FF)
        case .donut: return Color(hex: 0xFFD2EC)
        case .sandwich: return Color(hex: 0xC4F5C0)
        case .taco: return Color(hex: 0xFFD9A0)
        case .pasta: return Color(hex: 0xFFC8C0)
        case .cupcake: return Color(hex: 0xFFD0F0)
        case .hotDog: return Color(hex: 0xFFE6B8)
        case .pancakes: return Color(hex: 0xFFE7B0)
        case .salad: return Color(hex: 0xD5F5C8)
        case .smoothie: return Color(hex: 0xFFD0E8)
        case .cookies: return Color(hex: 0xF3D2A6)
        }
    }

    var accent: Color {
        switch self {
        case .pizza: return GameTheme.pizzaRed
        case .burger: return GameTheme.burgerOrange
        case .iceCream: return GameTheme.iceCreamPink
        case .donut: return GameTheme.donutPink
        case .sandwich: return GameTheme.sandwichGreen
        case .taco: return Color(hex: 0xFF8A3D)
        case .pasta: return Color(hex: 0xE85A4A)
        case .cupcake: return Color(hex: 0xFF6AD5)
        case .hotDog: return Color(hex: 0xF4A020)
        case .pancakes: return Color(hex: 0xE8A020)
        case .salad: return Color(hex: 0x4CAF50)
        case .smoothie: return Color(hex: 0xFF6AA8)
        case .cookies: return Color(hex: 0xC4783A)
        }
    }

    var speechHint: String {
        switch self {
        case .pizza: return "Add the right ingredients!"
        case .burger: return "Stack it yummy!"
        case .iceCream: return "Scoop, don't bake!"
        case .donut: return "Tap to add toppings!"
        case .sandwich: return "Stack the layers correctly!"
        case .taco: return "Fill the shell gently!"
        case .pasta: return "Sauce, then toppings!"
        case .cupcake: return "Frost it cute!"
        case .hotDog: return "Dog in the bun!"
        case .pancakes: return "Stack them fluffy!"
        case .salad: return "Keep it fresh!"
        case .smoothie: return "Blend it smooth!"
        case .cookies: return "Mix and bake!"
        }
    }
}
