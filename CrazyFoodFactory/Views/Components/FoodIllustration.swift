import SwiftUI

struct FoodIllustrationView: View {
    let food: FoodType
    var placed: [IngredientID] = []
    var melted: Bool = false
    var size: CGFloat = 180
    var cuteFace: Bool = false

    var body: some View {
        Group {
            if melted {
                ArtImage(name: "ArtMelted")
            } else if food == .donut {
                donutBuild
            } else {
                let pineapple = food == .pizza && placed.contains(.pineapple)
                ArtImage(name: GameArt.food(food, pineapple: pineapple, melted: melted))
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(food.displayName)
    }

    private var donutBuild: some View {
        let frosting = placed.first(where: {
            $0 == .chocolateFrosting || $0 == .strawberryFrosting || $0 == .vanillaFrosting
        })
        let hasSprinkles = placed.contains(.sprinkles) || placed.contains(.rainbowCandy)
        let hasCherry = placed.contains(.cherry)
        return ZStack {
            ArtImage(name: "ArtDonut")
            if let frosting {
                Circle()
                    .fill(frosting.trayColor.opacity(0.28))
                    .frame(width: size * 0.58, height: size * 0.58)
                    .blendMode(.multiply)
            }
            if hasSprinkles {
                ArtImage(name: "IngSprinkles")
                    .frame(width: size * 0.5, height: size * 0.5)
            }
            if hasCherry {
                ArtImage(name: "IngCherry")
                    .frame(width: size * 0.22, height: size * 0.22)
                    .offset(y: -size * 0.1)
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.72), value: placed)
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
        FoodIllustrationView(food: .donut, placed: [.donutBase], size: 140)
        FoodIllustrationView(food: .sandwich, size: 140)
    }
    .padding()
    .background(GameTheme.factoryLightBlue)
}
