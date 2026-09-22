import AVFoundation
import Foundation

@MainActor
final class AudioManager {
    static let shared = AudioManager()

    private var players: [AVAudioPlayer] = []
    private var didConfigure = false
    private var musicTimer: Timer?
    private var musicStep = 0
    private var soundEnabled = true
    private var musicEnabled = true

    private let fileMap: [String: String] = [
        "button": "button_tap.wav",
        "ingredient": "ingredient_place.wav",
        "success": "success.wav",
        "mistake": "mistake.wav",
        "chaos": "chaos.wav",
        "level": "level_complete.wav",
        "music": "background_music.mp3"
    ]

    private init() {}

    func prepare() {
        configure()
    }

    func applySettings(music: Bool, sound: Bool) {
        soundEnabled = sound
        musicEnabled = music
        if music {
            startMusic()
        } else {
            stopMusic()
        }
    }

    func tap() {
        playFile(named: fileMap["button"] ?? "")
        chirp(880, 0.05, 0.18)
    }

    func ingredient() {
        playFile(named: fileMap["ingredient"] ?? "")
        chirp(720, 0.06, 0.2)
        delay(0.05) { self.chirp(980, 0.07, 0.18) }
    }

    func success() {
        playFile(named: fileMap["success"] ?? "")
        chirp(660, 0.08, 0.22)
        delay(0.09) { self.chirp(880, 0.1, 0.22) }
        delay(0.2) { self.chirp(1175, 0.16, 0.26) }
    }

    func mistake() {
        playFile(named: fileMap["mistake"] ?? "")
        chirp(280, 0.12, 0.26)
        delay(0.1) { self.chirp(220, 0.14, 0.22) }
    }

    func chaos() {
        playFile(named: fileMap["chaos"] ?? "")
        chirp(380, 0.08, 0.3)
        delay(0.07) { self.chirp(640, 0.09, 0.32) }
        delay(0.16) { self.chirp(490, 0.12, 0.28) }
    }

    func levelComplete() {
        playFile(named: fileMap["level"] ?? "")
        success()
        delay(0.28) {
            self.chirp(1318, 0.12, 0.24)
            self.chirp(1568, 0.14, 0.22)
        }
    }

    func startMusic() {
        stopMusic()
        guard musicEnabled else { return }
        playFile(named: fileMap["music"] ?? "", loop: true)
        configure()
        musicTimer = Timer.scheduledTimer(withTimeInterval: 0.46, repeats: true) { [weak self] _ in
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
        let scale: [Double] = [392, 494, 523, 587, 659, 784]
        let pattern = [0, 2, 4, 2, 5, 4, 2, 1]
        let step = pattern[musicStep % pattern.count]
        musicStep += 1
        chirp(scale[step], 0.12, 0.06)
    }

    private func playFile(named name: String, loop: Bool = false) {
        guard !name.isEmpty else { return }
        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        guard let url = Bundle.main.url(forResource: base, withExtension: ext) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.volume = loop ? 0.28 : 0.7
            player.prepareToPlay()
            player.play()
            players.append(player)
            players = players.filter { $0.isPlaying || loop }
        } catch {
            // Missing or unreadable assets must never crash the game.
        }
    }

    private func configure() {
        guard !didConfigure else { return }
        didConfigure = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session setup is optional for the prototype.
        }
    }

    private func chirp(_ frequency: Double, _ duration: TimeInterval, _ volume: Float) {
        guard soundEnabled else { return }
        configure()
        let sampleRate = 22100.0
        let count = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: count)
        let twoPi = 2.0 * Double.pi
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let envelope = Float(1.0 - t / duration)
            samples[i] = Float(sin(twoPi * frequency * t)) * envelope * volume
        }
        guard let player = Self.player(from: samples, sampleRate: sampleRate) else { return }
        player.play()
        players.append(player)
        players = Array(players.suffix(12))
    }

    private func delay(_ time: TimeInterval, _ work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: work)
    }

    private static func player(from samples: [Float], sampleRate: Double) -> AVAudioPlayer? {
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
        return try? AVAudioPlayer(data: data)
    }
}
