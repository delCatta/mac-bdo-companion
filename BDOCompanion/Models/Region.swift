import Foundation

enum Region: String, CaseIterable, Codable, Identifiable {
    case na
    case eu
    case sea
    case sa

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .na: "NA"
        case .eu: "EU"
        case .sea: "SEA"
        case .sa: "SA"
        }
    }

    var timeZone: TimeZone {
        switch self {
        case .na: TimeZone(identifier: "America/Los_Angeles")!
        case .eu: TimeZone(identifier: "Europe/Berlin")!
        case .sea: TimeZone(identifier: "Asia/Singapore")!
        case .sa: TimeZone(identifier: "America/Sao_Paulo")!
        }
    }
}
