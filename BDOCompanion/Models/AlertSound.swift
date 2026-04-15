import Foundation

enum AlertSound: String, CaseIterable, Identifiable {
    case bossRoar = "boss_roar"
    case womanScream = "woman_scream"
    case maleScream = "male_scream"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bossRoar: "Monster Growl"
        case .womanScream: "Woman Scream"
        case .maleScream: "Male Scream"
        }
    }

    var filename: String { rawValue }
}
