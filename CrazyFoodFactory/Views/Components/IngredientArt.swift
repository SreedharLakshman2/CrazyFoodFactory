import SwiftUI

struct IngredientArt: View {
    let id: IngredientID

    var body: some View {
        ZStack {
            if isFrosting {
                Circle()
                    .fill(frostingTint.opacity(0.55))
            }
            if let name = GameArt.ingredient(id), GameArt.exists(name) {
                ArtImage(name: name)
                    .colorMultiply(isFrosting ? frostingTint : .white)
            } else {
                Image(systemName: "fork.knife")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(GameTheme.navy.opacity(0.35))
            }
        }
        .accessibilityHidden(true)
    }

    private var isFrosting: Bool {
        switch id {
        case .chocolateFrosting, .strawberryFrosting, .vanillaFrosting, .cupcakeFrosting:
            return true
        default:
            return false
        }
    }

    private var frostingTint: Color {
        switch id {
        case .chocolateFrosting: return Color(hex: 0x7A3B18)
        case .vanillaFrosting: return Color(hex: 0xFFE9A8)
        case .strawberryFrosting, .cupcakeFrosting: return Color(hex: 0xFF6AA8)
        default: return .white
        }
    }
}
