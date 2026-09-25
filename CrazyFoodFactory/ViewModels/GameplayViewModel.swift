import SwiftUI

enum CookPhase: Equatable {
    case assembling
    case readyToCook
    case cooking
    case plated
    case complete
}

@MainActor
final class GameplayViewModel: ObservableObject {
    let definition: FoodGameDefinition
    let level: LevelDefinition

    @Published var placed: [IngredientID]
    @Published var stepIndex: Int = 0
    @Published var phase: CookPhase = .assembling
    @Published var chefPose: ChefPose = .cooking
    @Published var speech: String?
    @Published var shake: CGFloat = 0
    @Published var foodBounce = false
    @Published var foodSpin = false
    @Published var sparkleTick = 0
    @Published var flying: IngredientID?
    @Published var cookProgress: Double = 0
    @Published var ovenGlow = false
    @Published var melted = false
    @Published var oopsText: String?
    @Published var activeChaos: ChaosEvent?
    @Published var mistakeCount = 0
    @Published var keptCrazy = false
    @Published var triggeredRandomChaos = false
    @Published var sandwichShake = false
    @Published var overlayScale: CGFloat = 1
    @Published var lastLesson: String?

    private var cookTask: Task<Void, Never>?

    init(definition: FoodGameDefinition, level: LevelDefinition) {
        self.definition = definition
        self.level = level
        self.placed = definition.prePlaced
        self.speech = definition.type.speechHint
        if definition.steps.first?.isOven == true {
            phase = .readyToCook
        }
    }

    var currentStep: GameStep? {
        guard stepIndex < definition.steps.count else { return nil }
        return definition.steps[stepIndex]
    }

    var starPreview: Int {
        max(1, 3 - mistakeCount / 2)
    }

    var canBake: Bool {
        currentStep?.isOven == true || phase == .readyToCook
    }

    func tapIngredient(_ id: IngredientID) {
        guard phase == .assembling || phase == .readyToCook else { return }
        guard activeChaos == nil else { return }

        if definition.type == .pizza && id == .pineapple {
            trigger(.pineapplePizza)
            return
        }

        guard let step = currentStep, !step.isOven else {
            reject(id, message: "Not yet!")
            return
        }

        if step.chaosIngredients.contains(id) {
            trigger(id == .pineapple ? .pineapplePizza : .wrongIngredient)
            return
        }

        if !step.accepted.contains(id) {
            reject(id, message: definition.strictOrder ? "OOPS!" : "Try another!")
            maybeRandomChaos()
            return
        }

        place(id)
    }

    func tapOven() {
        guard activeChaos == nil else { return }
        if definition.ovenIsTrap {
            melted = true
            trigger(.meltedIceCream)
            return
        }
        guard canBake else {
            chefPose = .shocked
            speech = "Not ready yet!"
            AudioManager.shared.mistake()
            return
        }
        startCooking()
    }

    func keepCrazy() {
        keptCrazy = true
        if let chaos = activeChaos, chaos.type == .pineapplePizza {
            placed.append(.pineapple)
            sparkleTick += 1
            lastLesson = IngredientID.pineapple.learnLine
            advanceIfNeeded(justPlaced: .pineapple, announcedName: IngredientID.pineapple.displayName)
        }
        activeChaos = nil
        chefPose = .happy
        speech = "That was CRAZY!"
        AudioManager.shared.tap()
    }

    func retry() {
        cookTask?.cancel()
        placed = definition.prePlaced
        stepIndex = 0
        phase = .assembling
        chefPose = .cooking
        speech = definition.type.speechHint
        lastLesson = nil
        shake = 0
        melted = false
        cookProgress = 0
        ovenGlow = false
        activeChaos = nil
        oopsText = nil
        foodSpin = false
        overlayScale = 1
        AudioManager.shared.tap()
    }

    func finishIfReady() {
        if phase == .plated || phase == .complete {
            phase = .complete
        }
    }

    func makeResult() -> FoodResult {
        let stars = max(1, min(3, starPreview))
        let message = keptCrazy ? "That was CRAZY!" : positiveMessage
        return FoodResult(
            food: definition.type,
            stars: stars,
            placed: placed,
            keptCrazy: keptCrazy,
            title: definition.resultTitle,
            message: message
        )
    }

    private var positiveMessage: String {
        switch definition.type {
        case .pizza: return "Looking tasty!"
        case .burger: return "Burger jump!"
        case .iceCream: return "Cool and yummy!"
        case .donut: return "YUMMY!"
        case .sandwich: return "Stacked perfectly!"
        case .taco: return "Taco fiesta!"
        case .pasta: return "Noodle dance!"
        case .cupcake: return "Sweet and cute!"
        case .hotDog: return "Ballpark yummy!"
        }
    }

    private func place(_ id: IngredientID) {
        flying = id
        AudioManager.shared.ingredient()
        Haptics.light()
        withAnimation(GameAnimations.ingredientFly) {
            foodBounce = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) { [weak self] in
            guard let self else { return }
            self.placed.append(id)
            self.flying = nil
            self.sparkleTick += 1
            self.chefPose = .happy
            self.speech = "\(id.displayName)!"
            self.lastLesson = "\(id.displayName)! \(id.kidFactShort)"
            self.advanceIfNeeded(justPlaced: id, announcedName: id.displayName)
            self.maybeRandomChaos()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.foodBounce = false
                if self.chefPose == .happy && self.phase == .assembling {
                    self.chefPose = .cooking
                }
            }
        }
    }

    private func advanceIfNeeded(justPlaced id: IngredientID, announcedName: String) {
        guard let step = currentStep, !step.isOven else { return }
        let count = placed.filter { step.accepted.contains($0) }.count
        if count >= step.minCount {
            stepIndex += 1
            if let next = currentStep {
                let hint = next.hint.isEmpty ? "Looking tasty!" : next.hint
                if next.isOven {
                    phase = .readyToCook
                    chefPose = .thumbsUp
                    if !definition.ovenIsTrap {
                        startCooking()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { [weak self] in
                    guard let self else { return }
                    if self.speech == "\(announcedName)!" {
                        self.speech = hint
                    }
                }
            } else {
                completeFood()
            }
        }
        _ = id
    }

    private func startCooking() {
        phase = .cooking
        ovenGlow = true
        chefPose = .cooking
        speech = "Baking..."
        AudioManager.shared.ingredient()
        cookTask?.cancel()
        cookTask = Task { [weak self] in
            guard let self else { return }
            for i in 1...20 {
                try? await Task.sleep(nanoseconds: 70_000_000)
                if Task.isCancelled { return }
                await MainActor.run {
                    self.cookProgress = Double(i) / 20
                }
            }
            await MainActor.run {
                self.ovenGlow = false
                self.completeFood()
            }
        }
    }

    private func completeFood() {
        phase = .complete
        chefPose = .celebrating
        speech = positiveMessage
        foodBounce = true
        foodSpin = definition.type == .donut
        overlayScale = definition.type == .sandwich ? 1.12 : 1.08
        sparkleTick += 2
        AudioManager.shared.success()
        Haptics.success()
    }

    private func reject(_ id: IngredientID, message: String) {
        mistakeCount += 1
        oopsText = message
        sandwichShake = definition.type == .sandwich || definition.type == .burger
        chefPose = .shocked
        speech = message
        AudioManager.shared.mistake()
        Haptics.warning()
        withAnimation(GameAnimations.errorWobble) {
            shake += 1
        }
        if definition.type == .burger || definition.type == .sandwich {
            triggerSoftWrong(id)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak self] in
            self?.oopsText = nil
            self?.sandwichShake = false
            if self?.chefPose == .shocked {
                self?.chefPose = .cooking
            }
        }
    }

    private func triggerSoftWrong(_ id: IngredientID) {
        flying = id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
            self?.flying = nil
        }
        if level.id >= 6 && Double.random(in: 0...1) < 0.35 {
            trigger(.wrongIngredient)
        }
    }

    private func trigger(_ type: ChaosEventType) {
        let event = ChaosEventManager.shared.event(for: type)
        present(event)
    }

    private func maybeRandomChaos() {
        guard let event = ChaosEventManager.shared.maybeRandom(
            chance: level.chaosChance,
            alreadyTriggered: triggeredRandomChaos
        ) else { return }
        triggeredRandomChaos = true
        present(event)
    }

    private func present(_ event: ChaosEvent) {
        mistakeCount += 1
        activeChaos = event
        chefPose = event.severity == .dramatic ? .falling : .shocked
        speech = event.subtitle
        AudioManager.shared.chaos()
        Haptics.medium()
        withAnimation(GameAnimations.errorWobble) {
            shake += 1
        }
        if event.retry == .continuePlay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
                if self?.activeChaos?.id == event.id {
                    self?.activeChaos = nil
                    self?.chefPose = .cooking
                }
            }
        }
    }
}
