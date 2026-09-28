import Foundation
import SwiftUI
import UIKit

@MainActor
enum KitchenFlowSelfTest {
    static func runAll() -> String {
        var lines: [String] = []
        let quiet = LevelDefinition(
            id: 99,
            title: "Test",
            requiredFoods: FoodType.allCases,
            chaosChance: 0,
            extraIngredients: false
        )
        let extra = LevelDefinition(
            id: 100,
            title: "Extra",
            requiredFoods: FoodType.allCases,
            chaosChance: 0,
            extraIngredients: true
        )

        for food in FoodType.allCases {
            lines.append(playthrough(food, level: quiet, label: food.rawValue))
            lines.append(playthrough(food, level: extra, label: "\(food.rawValue)-extra"))
        }

        lines.append(donutAnyOrder(level: quiet))
        lines.append(shareRender())
        return lines.joined(separator: "\n")
    }

    private static func playthrough(_ food: FoodType, level: LevelDefinition, label: String) -> String {
        let definition = FoodCatalog.definition(for: food, level: level)
        let game = GameplayViewModel(definition: definition, level: level)
        for step in definition.steps where !step.isOven {
            var placedForStep = 0
            for id in step.accepted where !step.chaosIngredients.contains(id) {
                if game.placed.contains(id) { continue }
                let before = game.placed.count
                game.tapIngredient(id)
                if game.placed.count > before {
                    placedForStep += 1
                }
                if placedForStep >= step.minCount { break }
            }
        }
        let assembled: Bool
        if definition.ovenIsTrap || definition.showsOven {
            assembled = game.phase == .readyToCook || game.phase == .cooking || game.phase == .complete
        } else {
            assembled = game.phase == .complete
        }
        let detail = "phase=\(String(describing: game.phase)) placed=\(game.placed.map(\.rawValue).joined(separator: ","))"
        return assembled ? "PASS \(label) \(detail)" : "FAIL \(label) \(detail)"
    }

    private static func donutAnyOrder(level: LevelDefinition) -> String {
        let definition = FoodCatalog.definition(for: .donut, level: level)
        let game = GameplayViewModel(definition: definition, level: level)
        game.tapIngredient(.sprinkles)
        game.tapIngredient(.strawberryFrosting)
        if game.phase == .complete {
            return "PASS donut-topping-first phase=complete"
        }
        return "FAIL donut-topping-first phase=\(String(describing: game.phase)) placed=\(game.placed.map(\.rawValue).joined(separator: ","))"
    }

    private static func shareRender() -> String {
        let reward = Reward(
            id: "food-sandwich",
            title: "Sandwich Star",
            subtitle: "You cooked Sandwich!",
            food: .sandwich,
            starsNeeded: 0
        )
        let image = RewardCardRenderer.image(for: reward)
        guard image.size.width > 40, let data = image.pngData(), data.count > 1000 else {
            return "FAIL share-render size=\(image.size)"
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("kido-share-test.png")
        try? data.write(to: url)
        return "PASS share-render \(Int(image.size.width))x\(Int(image.size.height)) bytes=\(data.count) path=\(url.path)"
    }
}
