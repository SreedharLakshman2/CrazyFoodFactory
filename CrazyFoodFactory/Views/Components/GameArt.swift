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
        case .dosa: return "ArtDosa"
        case .idli: return "ArtIdli"
        case .sambar: return "ArtSambar"
        case .vada: return "ArtVada"
        case .biryani: return "ArtBiryani"
        case .paneerTikka: return GameArt.exists("ArtPaneerTikka") ? "ArtPaneerTikka" : "IngPaneer"
        case .naanWrap: return GameArt.exists("ArtNaanWrap") ? "ArtNaanWrap" : "IngBread"
        case .chole: return GameArt.exists("ArtChole") ? "ArtChole" : "IngChickpeas"
        case .palak: return GameArt.exists("ArtPalak") ? "ArtPalak" : "ArtSalad"
        case .mangoLassi: return "ArtMangoLassi"
        case .nachos: return "ArtNachos"
        case .quesadilla: return "ArtQuesadilla"
        case .burrito: return "ArtBurrito"
        case .guacamole: return "ArtGuacamole"
        case .elote: return GameArt.exists("ArtElote") ? "ArtElote" : "IngCorn"
        case .ramen: return "ArtRamen"
        case .sushiRoll: return "ArtSushiRoll"
        case .falafel: return "ArtFalafel"
        case .hummus: return "ArtHummus"
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
        case .vanillaFrosting, .strawberryFrosting, .chocolateFrosting, .cupcakeFrosting:
            return "IngFrosting"
        case .strawberry: return "IngStrawberry"
        case .chocolate: return "IngChocolate"
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
        case .potato: return "IngPotato"
        case .rice: return "IngRice"
        case .paneer: return "IngPaneer"
        case .mango: return "IngMango"
        case .yogurt: return "IngYogurt"
        case .coconut: return "IngCoconut"
        case .coconutChutney: return GameArt.exists("IngCoconutChutney") ? "IngCoconutChutney" : "IngCoconut"
        case .sambar: return GameArt.exists("IngSambar") ? "IngSambar" : "ArtSambar"
        case .chickpeas: return "IngChickpeas"
        case .spinach: return GameArt.exists("IngSpinach") ? "IngSpinach" : "IngLettuce"
        case .corn: return "IngCorn"
        case .lime: return "IngLime"
        case .egg: return "IngEgg"
        case .nori: return "IngNori"
        case .cucumber: return "IngCucumber"
        case .chips: return "IngChips"
        case .falafel: return GameArt.exists("IngFalafel") ? "IngFalafel" : "ArtFalafel"
        case .hummus: return GameArt.exists("IngHummus") ? "IngHummus" : "ArtHummus"
        case .dosa: return GameArt.exists("IngDosa") ? "IngDosa" : "ArtDosa"
        case .idli: return GameArt.exists("IngIdli") ? "IngIdli" : "ArtIdli"
        case .vada: return GameArt.exists("IngVada") ? "IngVada" : "ArtVada"
        case .naan: return GameArt.exists("IngNaan") ? "IngNaan" : "IngBread"
        case .cilantro: return "IngBasil"
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
