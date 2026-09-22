import SwiftUI

struct FoodIcon: View {
    let food: FoodType
    var size: CGFloat = 44

    var body: some View {
        FoodIllustrationView(food: food, size: size)
    }
}

typealias ChaosPopup = ChaosEventView
