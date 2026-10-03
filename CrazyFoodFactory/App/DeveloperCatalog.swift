import Foundation

struct StudioApp: Identifiable, Equatable {
    let id: String
    let name: String
    let blurb: String
    let emoji: String

    var storeURL: URL {
        URL(string: "https://apps.apple.com/app/id\(id)")!
    }
}

enum DeveloperCatalog {
    static let developerID = "1677299144"
    static let storePage = URL(string: "https://apps.apple.com/developer/id1677299144")!

    static let apps: [StudioApp] = [
        StudioApp(id: "6448906516", name: "Count Mantras", blurb: "Calm counting and mantra practice.", emoji: "🕉️"),
        StudioApp(id: "6446448645", name: "Speedy Meter", blurb: "A cheerful speedometer for family trips.", emoji: "🚗"),
        StudioApp(id: "6446313196", name: "Kolour Pencil", blurb: "Color and doodle with chunky pencils.", emoji: "✏️"),
        StudioApp(id: "6802272622", name: "Coin Toss", blurb: "Flip a coin with a silly reveal.", emoji: "🪙"),
        StudioApp(id: "6802367964", name: "Space Explorer", blurb: "A gentle look at planets and stars.", emoji: "🚀"),
        StudioApp(id: "6800885773", name: "Sreeo Games", blurb: "A pocket of sreeo mini games.", emoji: "🎮"),
        StudioApp(id: "6801934819", name: "On Earth Recap", blurb: "A year-in-pictures recap.", emoji: "🌍"),
        StudioApp(id: "6802106645", name: "Story Beads", blurb: "Line up beads to tell a story.", emoji: "📿"),
        StudioApp(id: "6447702559", name: "Rock Paper Scissors", blurb: "The classic showdown, extra silly.", emoji: "✂️"),
    ]
}
