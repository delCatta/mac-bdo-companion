import Foundation

struct BossSpawn: Identifiable {
    let id = UUID()
    let bosses: [Boss]
    let dayOfWeek: DayOfWeek
    let hour: Int
    let minute: Int
    let activeUntil: Date?

    init(bosses: [Boss], dayOfWeek: DayOfWeek, hour: Int, minute: Int, activeUntil: Date? = nil) {
        self.bosses = bosses
        self.dayOfWeek = dayOfWeek
        self.hour = hour
        self.minute = minute
        self.activeUntil = activeUntil
    }

    var bossNames: String {
        bosses.map(\.displayName).joined(separator: ", ")
    }
}

enum DayOfWeek: Int, CaseIterable, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var shortName: String {
        switch self {
        case .sunday: "Sun"
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        }
    }
}

struct UpcomingSpawn: Identifiable {
    let id = UUID()
    let spawn: BossSpawn
    let date: Date
    let timeRemaining: TimeInterval

    var countdownText: String {
        let remaining = max(0, timeRemaining)
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60

        if remaining < 600 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var urgency: SpawnUrgency {
        if timeRemaining < 300 { return .imminent }
        if timeRemaining < 900 { return .soon }
        return .normal
    }

    var groupLabel: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

enum SpawnUrgency {
    case imminent
    case soon
    case normal
}
