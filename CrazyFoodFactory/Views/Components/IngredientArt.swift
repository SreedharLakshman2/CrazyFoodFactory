import SwiftUI

struct IngredientArt: View {
    let id: IngredientID

    var body: some View {
        Group {
            if let name = GameArt.ingredient(id), GameArt.exists(name) {
                ArtImage(name: name)
            } else {
                Image(systemName: "fork.knife")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(GameTheme.navy.opacity(0.35))
            }
        }
        .accessibilityHidden(true)
    }
}
