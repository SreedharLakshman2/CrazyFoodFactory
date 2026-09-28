import SwiftUI
import UIKit

enum GameArt {
    static func exists(_ name: String) -> Bool {
        UIImage(named: name) != nil
    }

    static func chef(for pose: ChefPose) -> String {
        switch pose {
        case .shocked, .falling, .sad:
            return "ChefShock"
        case .happy, .thumbsUp, .celebrating:
            return "ChefHappy"
        case .idle, .cooking:
            return "ChefIdle"
        }
    }

    static func food(_ type: FoodType, pineapple: Bool = false, melted: Bool = false) -> String {
        if melted { return "ArtMelted" }
        if type == .pizza && pineapple { return "ArtPizzaPineapple" }
        switch type {
        case .pizza: return "ArtPizza"
        case .burger: return "ArtBurger"
        case .iceCream: return "ArtIceCream"
        case .donut: return "ArtDonut"
        case .sandwich: return "ArtSandwich"
        case .taco: return "ArtTaco"
        case .pasta: return "ArtPasta"
        case .cupcake: return "ArtCupcake"
        case .hotDog: return "ArtHotDog"
        case .pancakes: return "ArtPancakes"
        case .salad: return "ArtSalad"
        case .smoothie: return "ArtSmoothie"
        case .cookies: return "ArtCookies"
        }
    }

    static func ingredient(_ id: IngredientID) -> String? {
        switch id {
        case .dough: return "IngDough"
        case .tomatoSauce: return "IngSauce"
        case .tomato: return "IngTomato"
        case .cheese: return "IngCheese"
        case .pepperoni: return "IngPepperoni"
        case .greenPepper: return "IngPepper"
        case .mushroom: return "IngMushroom"
        case .pineapple: return "IngPineapple"
        case .bun, .topBun: return "IngBun"
        case .hotdogBun: return "IngHotdogBun"
        case .patty: return "IngPatty"
        case .lettuce: return "IngLettuce"
        case .onion: return "IngOnion"
        case .cone: return "IngCone"
        case .vanilla, .scoop: return "IngVanilla"
        case .vanillaFrosting: return "IngVanilla"
        case .strawberry: return "IngStrawberry"
        case .strawberryFrosting, .cupcakeFrosting: return "IngFrosting"
        case .chocolate: return "IngChocolate"
        case .chocolateFrosting: return "IngChocolate"
        case .mint: return "IngMint"
        case .sprinkles, .rainbowCandy: return "IngSprinkles"
        case .cherry: return "IngCherry"
        case .donutBase: return "ArtDonut"
        case .bread, .topBread: return "IngBread"
        case .ham: return "IngHam"
        case .tortilla: return "IngTortilla"
        case .tacoBeef: return "IngBeef"
        case .salsa: return "IngSalsa"
        case .avocado: return "IngAvocado"
        case .noodles: return "IngNoodles"
        case .meatball: return "IngMeatball"
        case .basil: return "IngBasil"
        case .cupcakeBase: return "IngCupcake"
        case .candle: return "IngCandle"
        case .sausage: return "IngSausage"
        case .mustard: return "IngMustard"
        case .ketchup: return "IngKetchup"
        }
    }
}

struct ArtImage: View {
    let name: String
    var body: some View {
        if GameArt.exists(name) {
            Image(name)
                .resizable()
                .scaledToFit()
                .accessibilityHidden(true)
        }
    }
}
