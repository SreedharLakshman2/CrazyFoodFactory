import Foundation

struct GameStep: Identifiable, Equatable {
    let id: String
    let accepted: [IngredientID]
    let minCount: Int
    let isOven: Bool
    let chaosIngredients: [IngredientID]
    let hint: String

    init(
        id: String,
        accepted: [IngredientID],
        minCount: Int = 1,
        isOven: Bool = false,
        chaosIngredients: [IngredientID] = [],
        hint: String = ""
    ) {
        self.id = id
        self.accepted = accepted
        self.minCount = minCount
        self.isOven = isOven
        self.chaosIngredients = chaosIngredients
        self.hint = hint
    }
}

struct FoodGameDefinition: Identifiable, Equatable {
    let id: FoodType
    let type: FoodType
    let title: String
    let ingredients: [Ingredient]
    let steps: [GameStep]
    let prePlaced: [IngredientID]
    let showsOven: Bool
    let ovenIsTrap: Bool
    let strictOrder: Bool
    let checklist: [IngredientID]

    var resultTitle: String { type.resultTitle }
}
