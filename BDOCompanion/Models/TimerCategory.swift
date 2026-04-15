import Foundation

enum TimerCategory: Hashable, Codable, Identifiable {
    case boss
    case nodeWar
    case custom(id: String)

    var id: String {
        switch self {
        case .boss: "boss"
        case .nodeWar: "nodeWar"
        case .custom(let id): "custom-\(id)"
        }
    }

    var displayName: String {
        switch self {
        case .boss: "Bosses"
        case .nodeWar: "Node Wars"
        case .custom: "Custom"
        }
    }

    var sortOrder: Int {
        switch self {
        case .boss: 0
        case .nodeWar: 1
        case .custom: 2
        }
    }
}
