import Foundation

enum AlertSound: String, CaseIterable, Identifiable, Codable {
    case bossRoar = "boss_roar"
    case warHorn = "war_horn"
    case womanScream = "woman_scream"
    case maleScream = "male_scream"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bossRoar: "Monster Growl"
        case .warHorn: "War Horn"
        case .womanScream: "Woman Scream"
        case .maleScream: "Male Scream"
        }
    }

    var filename: String { rawValue }
}
