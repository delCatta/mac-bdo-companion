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
    let displayName: String
    let spawn: BossSpawn?
    let date: Date
    let timeRemaining: TimeInterval
    let category: TimerCategory

    init(spawn: BossSpawn, date: Date, timeRemaining: TimeInterval, category: TimerCategory) {
        self.displayName = spawn.bossNames
        self.spawn = spawn
        self.date = date
        self.timeRemaining = timeRemaining
        self.category = category
    }

    init(displayName: String, date: Date, timeRemaining: TimeInterval, category: TimerCategory) {
        self.displayName = displayName
        self.spawn = nil
        self.date = date
        self.timeRemaining = timeRemaining
        self.category = category
    }

    var countdownText: String {
        if timeRemaining <= 0 && timeRemaining > -60 {
            return "NOW"
        }
        if timeRemaining <= -60 && timeRemaining > -300 {
            let minutesAgo = Int(-timeRemaining) / 60
            return "\(minutesAgo)m ago"
        }

        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60

        if timeRemaining < 600 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var isActive: Bool { timeRemaining <= 0 && timeRemaining > -300 }

    var urgency: SpawnUrgency {
        if isActive { return .active }
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
    case active
    case imminent
    case soon
    case normal
}
