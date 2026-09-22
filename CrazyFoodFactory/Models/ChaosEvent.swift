import Foundation

enum ChaosEventType: String, Codable, CaseIterable, Identifiable {
    case pineapplePizza
    case meltedIceCream
    case burntFood
    case wrongIngredient
    case ingredientExplosion
    case foodTooBig
    case foodTooSmall
    case chefSlip
    case penguinVisit

    var id: String { rawValue }
}

enum ChaosSeverity: String, Codable {
    case giggle
    case oops
    case dramatic
}

enum ChaosRetryBehavior: String, Codable {
    case retryOnly
    case keepOrRetry
    case continuePlay
}

struct ChaosEvent: Identifiable, Equatable {
    let id: UUID
    let type: ChaosEventType
    let title: String
    let subtitle: String
    let severity: ChaosSeverity
    let retry: ChaosRetryBehavior
    let soundName: String

    init(
        id: UUID = UUID(),
        type: ChaosEventType,
        title: String,
        subtitle: String,
        severity: ChaosSeverity,
        retry: ChaosRetryBehavior,
        soundName: String = "chaos.wav"
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.severity = severity
        self.retry = retry
        self.soundName = soundName
    }

    static func == (lhs: ChaosEvent, rhs: ChaosEvent) -> Bool {
        lhs.id == rhs.id
    }

    static let pineapplePizza = ChaosEvent(
        type: .pineapplePizza,
        title: "PINEAPPLE ON PIZZA?!",
        subtitle: "Noooo!",
        severity: .dramatic,
        retry: .keepOrRetry
    )

    static let meltedIceCream = ChaosEvent(
        type: .meltedIceCream,
        title: "ICE CREAM IN THE OVEN?!",
        subtitle: "MELTED!",
        severity: .dramatic,
        retry: .retryOnly
    )

    static let burntFood = ChaosEvent(
        type: .burntFood,
        title: "TOASTY!",
        subtitle: "A little extra crispy!",
        severity: .oops,
        retry: .continuePlay
    )

    static let wrongIngredient = ChaosEvent(
        type: .wrongIngredient,
        title: "OOPS!",
        subtitle: "That one flew away!",
        severity: .giggle,
        retry: .continuePlay
    )

    static let ingredientExplosion = ChaosEvent(
        type: .ingredientExplosion,
        title: "KA-POW!",
        subtitle: "Ingredients everywhere!",
        severity: .oops,
        retry: .continuePlay
    )

    static let foodTooBig = ChaosEvent(
        type: .foodTooBig,
        title: "WHOA!",
        subtitle: "Giant-sized snack!",
        severity: .giggle,
        retry: .continuePlay
    )

    static let foodTooSmall = ChaosEvent(
        type: .foodTooSmall,
        title: "TINY BITE!",
        subtitle: "A mini masterpiece!",
        severity: .giggle,
        retry: .continuePlay
    )

    static let chefSlip = ChaosEvent(
        type: .chefSlip,
        title: "WHOOPS!",
        subtitle: "The chef slipped on sauce!",
        severity: .oops,
        retry: .continuePlay
    )

    static let penguinVisit = ChaosEvent(
        type: .penguinVisit,
        title: "OOPS! A LITTLE CHAOS!",
        subtitle: "A penguin joined the factory!",
        severity: .oops,
        retry: .continuePlay
    )
}
