import SwiftUI

struct FoodIllustrationView: View {
    let food: FoodType
    var placed: [IngredientID] = []
    var melted: Bool = false
    var size: CGFloat = 180
    var cuteFace: Bool = false

    var body: some View {
        let pineapple = food == .pizza && placed.contains(.pineapple)
        ArtImage(name: GameArt.food(food, pineapple: pineapple, melted: melted))
            .frame(width: size, height: size)
            .accessibilityLabel(food.displayName)
    }
}

struct OvenArt: View {
    var glowing: Bool = false
    var meltedInside: Bool = false

    var body: some View {
        ZStack {
            ArtImage(name: "ArtOven")
            if meltedInside {
                ArtImage(name: "ArtMelted")
                    .scaleEffect(0.30)
                    .offset(y: 12)
            }
        }
        .shadow(color: glowing ? Color.orange.opacity(0.4) : .clear, radius: 16)
        .accessibilityLabel(glowing ? "Hot oven" : "Oven")
    }
}

struct PenguinArt: View {
    var body: some View {
        ArtImage(name: "ArtPenguin")
            .accessibilityLabel("Penguin visitor")
    }
}

#Preview {
    VStack {
        FoodIllustrationView(food: .pizza, size: 140)
        FoodIllustrationView(food: .burger, size: 140)
        FoodIllustrationView(food: .iceCream, size: 140)
        FoodIllustrationView(food: .donut, size: 140)
        FoodIllustrationView(food: .sandwich, size: 140)
    }
    .padding()
    .background(GameTheme.factoryLightBlue)
}
