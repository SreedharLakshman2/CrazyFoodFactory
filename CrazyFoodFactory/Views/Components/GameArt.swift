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
        }
    }

    static func ingredient(_ id: IngredientID) -> String? {
        switch id {
        case .tomatoSauce, .tomato: return "IngTomato"
        case .cheese: return "IngCheese"
        case .pepperoni: return "IngPepperoni"
        case .mushroom: return "IngMushroom"
        case .pineapple: return "IngPineapple"
        default: return nil
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
