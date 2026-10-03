import SwiftUI

/// Chef in the middle with full food art around them — sized to the available
/// frame so nothing is cropped on iPhone or iPad.
struct ChefFoodStage: View {
    var pose: ChefPose = .idle
    var foods: [FoodType]
    var chefSize: CGFloat
    var foodSize: CGFloat
    var showsSpatula: Bool = true

    private let anchors: [CGPoint] = [
        CGPoint(x: 0.16, y: 0.34),
        CGPoint(x: 0.84, y: 0.28),
        CGPoint(x: 0.14, y: 0.76),
        CGPoint(x: 0.86, y: 0.74)
    ]

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let snack = min(foodSize, max(36, min(width * 0.20, height * 0.28)))
            let chef = min(chefSize, max(72, min(height * 0.68, width * 0.44)))
            ZStack {
                ChefCharacter(pose: pose, size: chef, showsSpatula: showsSpatula)
                    .position(x: width * 0.5, y: height * 0.50)
                ForEach(Array(foods.prefix(4).enumerated()), id: \.element) { index, food in
                    let point = anchors[index % anchors.count]
                    FoodIllustrationView(food: food, size: snack)
                        .position(x: point.x * width, y: point.y * height)
                        .accessibilityHidden(true)
                }
            }
            .frame(width: width, height: height)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
    }
}

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
            } else if GameArt.exists(GameArt.food(food, pineapple: food == .pizza && placed.contains(.pineapple), melted: melted)) {
                let pineapple = food == .pizza && placed.contains(.pineapple)
                ArtImage(name: GameArt.food(food, pineapple: pineapple, melted: melted))
            } else {
                FoodPlatePlaceholder(food: food, size: size)
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

struct FoodPlatePlaceholder: View {
    let food: FoodType
    var size: CGFloat = 140

    private var bits: [IngredientID] {
        Array(
            FoodCatalog.definition(
                for: food,
                level: LevelCatalog.level(1)
            ).checklist.prefix(3)
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, food.cardColor, food.accent.opacity(0.35)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            Circle()
                .stroke(Color.white, lineWidth: max(3, size * 0.04))
            HStack(spacing: -size * 0.08) {
                ForEach(bits, id: \.self) { id in
                    IngredientArt(id: id)
                        .frame(width: size * 0.38, height: size * 0.38)
                }
            }
        }
        .shadow(color: food.accent.opacity(0.22), radius: 8, y: 4)
        .accessibilityHidden(true)
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
