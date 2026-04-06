import Foundation

enum Boss: String, CaseIterable, Codable, Identifiable {
    case kzarka
    case karanda
    case kutum
    case nouver
    case offinTett
    case garmoth
    case quint
    case muraka
    case vell
    case goldenPigKing
    case bulgasal
    case sangoon
    case uturi

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .kzarka: "Kzarka"
        case .karanda: "Karanda"
        case .kutum: "Kutum"
        case .nouver: "Nouver"
        case .offinTett: "Offin Tett"
        case .garmoth: "Garmoth"
        case .quint: "Quint"
        case .muraka: "Muraka"
        case .vell: "Vell"
        case .goldenPigKing: "Golden Pig King"
        case .bulgasal: "Bulgasal"
        case .sangoon: "Sangoon"
        case .uturi: "Uturi"
        }
    }

    var category: BossCategory {
        switch self {
        case .kzarka, .karanda, .kutum, .nouver:
            return .field
        case .offinTett, .garmoth:
            return .special
        case .quint, .muraka:
            return .world
        case .vell:
            return .ocean
        case .goldenPigKing, .bulgasal, .sangoon, .uturi:
            return .loml
        }
    }

    var iconSymbol: String {
        switch self {
        case .kzarka: "flame.fill"
        case .karanda: "bird.fill"
        case .kutum: "tortoise.fill"
        case .nouver: "wind"
        case .offinTett: "sparkles"
        case .garmoth: "bolt.fill"
        case .quint: "figure.stand"
        case .muraka: "mountain.2.fill"
        case .vell: "water.waves"
        case .goldenPigKing: "crown.fill"
        case .bulgasal: "lizard.fill"
        case .sangoon: "moonphase.waning.crescent"
        case .uturi: "leaf.fill"
        }
    }
}

enum BossCategory: String, CaseIterable {
    case field = "Field Bosses"
    case special = "Special Bosses"
    case world = "World Bosses"
    case ocean = "Ocean Boss"
    case loml = "LOML Bosses"
}
