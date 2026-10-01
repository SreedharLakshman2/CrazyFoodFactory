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
            } else if let emoji = clayEmoji {
                Text(emoji)
                    .font(.system(size: 34))
            } else {
                ZStack {
                    Circle().fill(id.trayColor)
                    Text(String(id.displayName.prefix(1)))
                        .font(GameFont.headline(18))
                        .foregroundColor(GameTheme.navy)
                }
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

    private var clayEmoji: String? {
        switch id {
        case .potato: return "🥔"
        case .rice: return "🍚"
        case .mango: return "🥭"
        case .yogurt: return "🥛"
        case .coconut, .coconutChutney: return "🥥"
        case .paneer: return "🧀"
        case .chickpeas: return "🫘"
        case .corn: return "🌽"
        case .lime: return "🍋"
        case .egg: return "🥚"
        case .nori: return "🍙"
        case .cucumber: return "🥒"
        case .chips: return "🌮"
        case .falafel: return "🧆"
        case .hummus: return "🥣"
        case .dosa: return "🥞"
        case .idli: return "⚪"
        case .vada: return "🍩"
        case .naan: return "🫓"
        case .sambar: return "🍲"
        case .spinach: return "🥬"
        default: return nil
        }
    }
}
