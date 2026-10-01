import SwiftUI

enum FoodKitchen: String, CaseIterable, Identifiable {
    case classics
    case southIndian
    case indian
    case mexican
    case world

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classics: return "Classics"
        case .southIndian: return "South Indian"
        case .indian: return "Indian"
        case .mexican: return "Mexican"
        case .world: return "Around the World"
        }
    }
}

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
    case dosa
    case idli
    case sambar
    case vada
    case biryani
    case paneerTikka
    case naanWrap
    case chole
    case palak
    case mangoLassi
    case nachos
    case quesadilla
    case burrito
    case guacamole
    case elote
    case ramen
    case sushiRoll
    case falafel
    case hummus

    var id: String { rawValue }

    var kitchen: FoodKitchen {
        switch self {
        case .pizza, .burger, .iceCream, .donut, .sandwich, .pasta, .cupcake,
             .hotDog, .pancakes, .salad, .smoothie, .cookies:
            return .classics
        case .dosa, .idli, .sambar, .vada:
            return .southIndian
        case .biryani, .paneerTikka, .naanWrap, .chole, .palak, .mangoLassi:
            return .indian
        case .taco, .nachos, .quesadilla, .burrito, .guacamole, .elote:
            return .mexican
        case .ramen, .sushiRoll, .falafel, .hummus:
            return .world
        }
    }

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
        case .dosa: return "Dosa"
        case .idli: return "Idli"
        case .sambar: return "Sambar"
        case .vada: return "Vada"
        case .biryani: return "Biryani"
        case .paneerTikka: return "Paneer Tikka"
        case .naanWrap: return "Naan Wrap"
        case .chole: return "Chole"
        case .palak: return "Palak"
        case .mangoLassi: return "Mango Lassi"
        case .nachos: return "Nachos"
        case .quesadilla: return "Quesadilla"
        case .burrito: return "Burrito"
        case .guacamole: return "Guacamole"
        case .elote: return "Elote"
        case .ramen: return "Ramen"
        case .sushiRoll: return "Sushi Roll"
        case .falafel: return "Falafel"
        case .hummus: return "Hummus"
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
        case .dosa: return "Spread a Dosa!"
        case .idli: return "Steam the Idli!"
        case .sambar: return "Stir the Sambar!"
        case .vada: return "Fry a Vada!"
        case .biryani: return "Layer the Biryani!"
        case .paneerTikka: return "Grill Paneer Tikka!"
        case .naanWrap: return "Roll a Naan Wrap!"
        case .chole: return "Cook the Chole!"
        case .palak: return "Mix Palak Paneer!"
        case .mangoLassi: return "Blend Mango Lassi!"
        case .nachos: return "Pile the Nachos!"
        case .quesadilla: return "Fold a Quesadilla!"
        case .burrito: return "Wrap a Burrito!"
        case .guacamole: return "Mash Guacamole!"
        case .elote: return "Dress the Elote!"
        case .ramen: return "Build a Ramen Bowl!"
        case .sushiRoll: return "Roll the Sushi!"
        case .falafel: return "Stuff the Falafel!"
        case .hummus: return "Scoop the Hummus!"
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
        case .dosa: return "Dosa Crisp!"
        case .idli: return "Idli Soft!"
        case .sambar: return "Sambar Warm!"
        case .vada: return "Vada Crunch!"
        case .biryani: return "Biryani Wow!"
        case .paneerTikka: return "Tikka Time!"
        case .naanWrap: return "Wrap Ready!"
        case .chole: return "Chole Yum!"
        case .palak: return "Palak Green!"
        case .mangoLassi: return "Lassi Sip!"
        case .nachos: return "Nacho Party!"
        case .quesadilla: return "Queso Melt!"
        case .burrito: return "Burrito Hug!"
        case .guacamole: return "Guac Good!"
        case .elote: return "Elote Yay!"
        case .ramen: return "Ramen Slurp!"
        case .sushiRoll: return "Sushi Roll!"
        case .falafel: return "Falafel Fun!"
        case .hummus: return "Hummus Dip!"
        }
    }

    var yumLine: String {
        switch self {
        case .pizza: return "Looking tasty!"
        case .burger: return "Burger jump!"
        case .iceCream: return "Cool and yummy!"
        case .donut: return "YUMMY!"
        case .sandwich: return "Stacked perfectly!"
        case .taco: return "Taco fiesta!"
        case .pasta: return "Noodle dance!"
        case .cupcake: return "Sweet and cute!"
        case .hotDog: return "Ballpark yummy!"
        case .pancakes: return "Fluffy stack!"
        case .salad: return "Crunchy fresh!"
        case .smoothie: return "Sip sip yay!"
        case .cookies: return "Cookie dance!"
        case .dosa: return "Crispy dosa!"
        case .idli: return "Soft and steamy!"
        case .sambar: return "Warm and cozy!"
        case .vada: return "Crunchy hole!"
        case .biryani: return "Spice hug!"
        case .paneerTikka: return "Cheesy sizzle!"
        case .naanWrap: return "Wrap and go!"
        case .chole: return "Bean party!"
        case .palak: return "Green and creamy!"
        case .mangoLassi: return "Mango wow!"
        case .nachos: return "Chip pile!"
        case .quesadilla: return "Cheesy fold!"
        case .burrito: return "Big wrap hug!"
        case .guacamole: return "Mash mash yay!"
        case .elote: return "Corn party!"
        case .ramen: return "Slurp time!"
        case .sushiRoll: return "Roll and nibble!"
        case .falafel: return "Crunchy balls!"
        case .hummus: return "Dip dip yum!"
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
        case .dosa: return Color(hex: 0xFFE6B0)
        case .idli: return Color(hex: 0xFFF4E0)
        case .sambar: return Color(hex: 0xFFD0A8)
        case .vada: return Color(hex: 0xF6D2A0)
        case .biryani: return Color(hex: 0xFFE3A0)
        case .paneerTikka: return Color(hex: 0xFFE8C8)
        case .naanWrap: return Color(hex: 0xF8E0B8)
        case .chole: return Color(hex: 0xF5CFA0)
        case .palak: return Color(hex: 0xC8F0C0)
        case .mangoLassi: return Color(hex: 0xFFE8A0)
        case .nachos: return Color(hex: 0xFFE0A8)
        case .quesadilla: return Color(hex: 0xFFE7B8)
        case .burrito: return Color(hex: 0xF5D9A8)
        case .guacamole: return Color(hex: 0xC8F5B0)
        case .elote: return Color(hex: 0xFFF2A8)
        case .ramen: return Color(hex: 0xFFD8C8)
        case .sushiRoll: return Color(hex: 0xD4F5E0)
        case .falafel: return Color(hex: 0xE8D4A8)
        case .hummus: return Color(hex: 0xF3E2A8)
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
        case .dosa: return Color(hex: 0xE09A2A)
        case .idli: return Color(hex: 0xC9A227)
        case .sambar: return Color(hex: 0xE07020)
        case .vada: return Color(hex: 0xC4783A)
        case .biryani: return Color(hex: 0xE8A020)
        case .paneerTikka: return Color(hex: 0xE07040)
        case .naanWrap: return Color(hex: 0xD4A04A)
        case .chole: return Color(hex: 0xC45A20)
        case .palak: return Color(hex: 0x3D9A4A)
        case .mangoLassi: return Color(hex: 0xF4B020)
        case .nachos: return Color(hex: 0xFF8A3D)
        case .quesadilla: return Color(hex: 0xE8A020)
        case .burrito: return Color(hex: 0xD4782A)
        case .guacamole: return Color(hex: 0x5AAB40)
        case .elote: return Color(hex: 0xE8C020)
        case .ramen: return Color(hex: 0xE85A4A)
        case .sushiRoll: return Color(hex: 0x2E8B6A)
        case .falafel: return Color(hex: 0xC4783A)
        case .hummus: return Color(hex: 0xD4A84A)
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
        case .dosa: return "Crispy crepe, then filling!"
        case .idli: return "Soft cakes, then chutney!"
        case .sambar: return "Veggies in the stew!"
        case .vada: return "Crunchy ring, then dip!"
        case .biryani: return "Rice, then tasty bits!"
        case .paneerTikka: return "Cheese cubes, then veggies!"
        case .naanWrap: return "Naan, then fill it!"
        case .chole: return "Chickpeas, then naan!"
        case .palak: return "Greens, then paneer!"
        case .mangoLassi: return "Mango, then yogurt. No oven!"
        case .nachos: return "Chips, then toppings!"
        case .quesadilla: return "Tortilla, then cheese!"
        case .burrito: return "Wrap the fillings tight!"
        case .guacamole: return "Mash avocado first!"
        case .elote: return "Corn, then toppings!"
        case .ramen: return "Noodles, then toppings!"
        case .sushiRoll: return "Seaweed, rice, then fill!"
        case .falafel: return "Pita, then falafel!"
        case .hummus: return "Dip first, then dunk!"
        }
    }

    static func foods(in kitchen: FoodKitchen) -> [FoodType] {
        allCases.filter { $0.kitchen == kitchen }
    }
}
