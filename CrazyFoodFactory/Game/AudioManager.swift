import AVFoundation
import Combine
import Foundation

@MainActor
final class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()

    @Published private(set) var isSpeaking = false
    @Published private(set) var isPaused = false

    private var toneCache: [String: Data] = [:]
    private var players: [AVAudioPlayer] = []
    private var didConfigure = false
    private var musicTimer: Timer?
    private var musicStep = 0
    private var soundEnabled = true
    private var musicEnabled = true
    private var speechEnabled = true
    private var speaker: AVSpeechSynthesizer?
    private var currentUtterance: AVSpeechUtterance?
    private var lastSpokenText: String?
    private var spokenUTF16Offset: Int = 0
    private var speechIntent: SpeechIntent = .idle

    private enum SpeechIntent {
        case idle, speaking, pausing, paused, stopping
    }

    private override init() {
        super.init()
    }

    func prepare() {
        configure()
    }

    func applySettings(music: Bool, sound: Bool, speech: Bool = true) {
        soundEnabled = sound
        musicEnabled = music
        speechEnabled = speech
        if music {
            startMusic()
        } else {
            stopMusic()
        }
        if !speech {
            stopSpeech()
        }
    }

    func tap() {
        chirp(880, 0.05, 0.18)
    }

    func ingredient() {
        chirp(720, 0.06, 0.2)
        delay(0.05) { self.chirp(980, 0.07, 0.18) }
    }

    func success() {
        chirp(660, 0.08, 0.22)
        delay(0.09) { self.chirp(880, 0.1, 0.22) }
        delay(0.2) { self.chirp(1175, 0.16, 0.26) }
    }

    func celebrate() {
        success()
        delay(0.22) { self.chirp(1318, 0.1, 0.22) }
        delay(0.34) { self.chirp(1568, 0.12, 0.24) }
        delay(0.48) { self.chirp(1760, 0.16, 0.2) }
        speak("Yay! You did it!")
    }

    func mistake() {
        chirp(280, 0.12, 0.26)
        delay(0.1) { self.chirp(220, 0.14, 0.22) }
    }

    func chaos() {
        chirp(380, 0.08, 0.3)
        delay(0.07) { self.chirp(640, 0.09, 0.32) }
        delay(0.16) { self.chirp(490, 0.12, 0.28) }
    }

    func levelComplete() {
        celebrate()
        delay(0.56) { self.chirp(2093, 0.18, 0.2) }
    }

    func speakIngredient(_ id: IngredientID) {
        speak("\(id.displayName)! \(id.kidFactShort)")
    }

    func speakFood(_ food: FoodType) {
        speak("Let's make \(food.displayName)!")
    }

    func speak(_ text: String, force: Bool = false) {
        guard force || speechEnabled, !text.isEmpty else { return }
        configure()
        let synth = preparedSpeaker()
        lastSpokenText = text
        spokenUTF16Offset = 0
        let utterance = makeUtterance(text)
        currentUtterance = utterance
        speechIntent = .speaking
        publish(speaking: true, paused: false)

        if synth.isSpeaking || synth.isPaused {
            synth.stopSpeaking(at: .immediate)
            Task { @MainActor in
                guard currentUtterance === utterance else { return }
                preparedSpeaker().speak(utterance)
            }
        } else {
            preparedSpeaker().speak(utterance)
        }
    }

    func toggleSpeech(_ text: String) {
        if speaker?.isPaused == true || speechIntent == .paused || speechIntent == .pausing || isPaused {
            resumeSpeech()
        } else if speaker?.isSpeaking == true || speechIntent == .speaking || isSpeaking {
            pauseSpeech()
        } else {
            speak(text, force: true)
        }
    }

    func pauseSpeech() {
        guard let synth = speaker else {
            publish(speaking: false, paused: false)
            speechIntent = .idle
            return
        }
        if synth.isPaused || speechIntent == .paused {
            speechIntent = .paused
            publish(speaking: true, paused: true)
            return
        }
        guard synth.isSpeaking || speechIntent == .speaking || isSpeaking else {
            publish(speaking: false, paused: false)
            speechIntent = .idle
            return
        }
        speechIntent = .pausing
        _ = synth.pauseSpeaking(at: .immediate)
        speechIntent = synth.isPaused || speechIntent == .pausing ? .paused : speechIntent
        publish(speaking: true, paused: true)
    }

    func resumeSpeech() {
        speechIntent = .speaking
        if let synth = speaker, synth.isPaused {
            synth.continueSpeaking()
            publish(speaking: true, paused: false)
            return
        }
        if speaker?.isSpeaking != true, let remaining = remainingSpeechText() {
            speak(remaining, force: true)
            return
        }
        if speaker?.isSpeaking == true {
            publish(speaking: true, paused: false)
            return
        }
        publish(speaking: false, paused: false)
        speechIntent = .idle
    }

    func stopSpeech() {
        speechIntent = .stopping
        currentUtterance = nil
        lastSpokenText = nil
        spokenUTF16Offset = 0
        speaker?.stopSpeaking(at: .immediate)
        publish(speaking: false, paused: false)
        speechIntent = .idle
    }

    private func makeUtterance(_ text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.pitchMultiplier = 1.18
        utterance.volume = 1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            ?? AVSpeechSynthesisVoice(language: "en-GB")
        return utterance
    }

    private func publish(speaking: Bool, paused: Bool) {
        isSpeaking = speaking
        isPaused = paused
    }

    private func remainingSpeechText() -> String? {
        guard let text = lastSpokenText, !text.isEmpty else { return nil }
        let nsText = text as NSString
        let offset = min(max(spokenUTF16Offset, 0), nsText.length)
        if offset <= 0 { return text }
        let remaining = nsText.substring(from: offset)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return remaining.isEmpty ? text : remaining
    }

    private func applyDelegate(for utterance: AVSpeechUtterance, _ update: () -> Void) {
        guard utterance === currentUtterance else { return }
        update()
    }

    private func preparedSpeaker() -> AVSpeechSynthesizer {
        if let speaker { return speaker }
        let synth = AVSpeechSynthesizer()
        synth.delegate = self
        speaker = synth
        return synth
    }

    func startMusic() {
        stopMusic()
        guard musicEnabled else { return }
        configure()
        musicTimer = Timer.scheduledTimer(withTimeInterval: 0.38, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tickMusic()
            }
        }
        if let musicTimer {
            RunLoop.main.add(musicTimer, forMode: .common)
        }
    }

    func stopMusic() {
        musicTimer?.invalidate()
        musicTimer = nil
    }

    private func tickMusic() {
        guard musicEnabled else { return }
        let melody: [Double] = [523, 659, 784, 659, 880, 784, 659, 587]
        let bass: [Double] = [196, 196, 262, 196, 220, 262, 196, 175]
        let step = musicStep % melody.count
        musicStep += 1
        chirp(bass[step], 0.22, 0.045)
        chirp(melody[step], 0.14, 0.07)
        if step == 4 {
            chirp(1046, 0.08, 0.05)
        }
    }

    private func configure() {
        guard !didConfigure else { return }
        didConfigure = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session setup is optional for the prototype.
        }
    }

    private func chirp(_ frequency: Double, _ duration: TimeInterval, _ volume: Float) {
        guard soundEnabled else { return }
        configure()
        let key = "\(Int(frequency))-\(Int(duration * 1000))-\(Int(volume * 100))"
        let data: Data
        if let cached = toneCache[key] {
            data = cached
        } else {
            data = Self.wavData(frequency: frequency, duration: duration, volume: volume)
            toneCache[key] = data
        }
        guard let player = try? AVAudioPlayer(data: data) else { return }
        player.play()
        players.append(player)
        players = Array(players.suffix(16))
    }

    private func delay(_ time: TimeInterval, _ work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: work)
    }

    private static func wavData(frequency: Double, duration: TimeInterval, volume: Float) -> Data {
        let sampleRate = 16000.0
        let count = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: count)
        let twoPi = 2.0 * Double.pi
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let envelope = Float(sin(Double.pi * t / duration))
            samples[i] = Float(sin(twoPi * frequency * t)) * envelope * volume
        }

        var data = Data()
        let channels: Int32 = 1
        let bps: Int16 = 16
        let byteRate = Int32(sampleRate) * channels * Int32(bps / 8)
        let blockAlign = Int16(channels * Int32(bps / 8))
        let dataSize = Int32(samples.count * 2)
        func append(_ value: UInt32) {
            var v = value.littleEndian
            data.append(Data(bytes: &v, count: 4))
        }
        func append16(_ value: UInt16) {
            var v = value.littleEndian
            data.append(Data(bytes: &v, count: 2))
        }
        data.append(contentsOf: [0x52, 0x49, 0x46, 0x46])
        append(UInt32(36 + dataSize))
        data.append(contentsOf: [0x57, 0x41, 0x56, 0x45, 0x66, 0x6D, 0x74, 0x20])
        append(16)
        append16(1)
        append16(UInt16(channels))
        append(UInt32(sampleRate))
        append(UInt32(byteRate))
        append16(UInt16(bitPattern: blockAlign))
        append16(UInt16(bitPattern: bps))
        data.append(contentsOf: [0x64, 0x61, 0x74, 0x61])
        append(UInt32(dataSize))
        for sample in samples {
            let clipped = max(-1, min(1, sample))
            var value = Int16(clipped * Float(Int16.max)).littleEndian
            data.append(Data(bytes: &value, count: 2))
        }
        return data
    }
}

extension AudioManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                speechIntent = .speaking
                publish(speaking: true, paused: false)
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                currentUtterance = nil
                speechIntent = .idle
                publish(speaking: false, paused: false)
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                speechIntent = .paused
                publish(speaking: true, paused: true)
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                speechIntent = .speaking
                publish(speaking: true, paused: false)
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                spokenUTF16Offset = characterRange.location
            }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            applyDelegate(for: utterance) {
                if speechIntent == .pausing || speechIntent == .paused {
                    speechIntent = .paused
                    publish(speaking: true, paused: true)
                    return
                }
                if speechIntent == .speaking {
                    return
                }
                currentUtterance = nil
                speechIntent = .idle
                publish(speaking: false, paused: false)
            }
        }
    }
}
