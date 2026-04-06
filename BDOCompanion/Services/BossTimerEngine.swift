import Foundation
import Observation

@MainActor
@Observable
final class BossTimerEngine {
    var upcomingSpawns: [UpcomingSpawn] = []
    var nextSpawn: UpcomingSpawn? { upcomingSpawns.first }

    private var timer: Timer?

    var selectedRegion: Region = .na {
        didSet { recompute() }
    }

    var trackedBosses: Set<Boss> = Set(Boss.allCases) {
        didSet { recompute() }
    }

    init() {
        recompute()
        startTimer()
    }

    deinit {
        // Timer retains its target weakly via closure, so it will just no-op
    }

    func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        let now = Date()

        // Check if the first spawn has passed; if so, recompute
        if let first = upcomingSpawns.first, first.date <= now {
            recompute()
            return
        }

        // Update time remaining for all spawns
        var updated: [UpcomingSpawn] = []
        for spawn in upcomingSpawns {
            let remaining = spawn.date.timeIntervalSince(now)
            updated.append(UpcomingSpawn(
                spawn: spawn.spawn,
                date: spawn.date,
                timeRemaining: remaining
            ))
        }
        upcomingSpawns = updated
    }

    func recompute() {
        let now = Date()
        let calendar = Calendar.current
        let region = selectedRegion
        let tracked = trackedBosses
        let allSpawns = BossSchedule.spawns(for: region)

        var upcoming: [UpcomingSpawn] = []

        // Generate dates for this week and next week
        for weekOffset in 0...1 {
            for spawn in allSpawns {
                // Check if any boss in this spawn slot is tracked
                let relevantBosses = spawn.bosses.filter { tracked.contains($0) }
                guard !relevantBosses.isEmpty else { continue }

                if let date = nextDate(
                    for: spawn.dayOfWeek,
                    hour: spawn.hour,
                    minute: spawn.minute,
                    in: region.timeZone,
                    weekOffset: weekOffset,
                    relativeTo: now,
                    calendar: calendar
                ) {
                    let remaining = date.timeIntervalSince(now)
                    guard remaining > 0 else { continue }

                    let filteredSpawn = BossSpawn(
                        bosses: relevantBosses,
                        dayOfWeek: spawn.dayOfWeek,
                        hour: spawn.hour,
                        minute: spawn.minute
                    )

                    upcoming.append(UpcomingSpawn(
                        spawn: filteredSpawn,
                        date: date,
                        timeRemaining: remaining
                    ))
                }
            }
        }

        // Sort by date, take next 20
        upcoming.sort { $0.date < $1.date }

        // Deduplicate (same date can appear from week 0 and week 1)
        var seen = Set<Date>()
        upcoming = upcoming.filter { seen.insert($0.date).inserted }

        upcomingSpawns = Array(upcoming.prefix(20))
    }

    private nonisolated func nextDate(
        for dayOfWeek: DayOfWeek,
        hour: Int,
        minute: Int,
        in timeZone: TimeZone,
        weekOffset: Int,
        relativeTo now: Date,
        calendar: Calendar
    ) -> Date? {
        var cal = calendar
        cal.timeZone = timeZone

        // Get the start of the current week in the region timezone
        guard let startOfWeek = cal.dateInterval(of: .weekOfYear, for: now)?.start else {
            return nil
        }

        // Calculate days offset from Sunday (weekday 1)
        let daysFromSunday = dayOfWeek.rawValue - 1

        guard let dayDate = cal.date(byAdding: .day, value: daysFromSunday + (weekOffset * 7), to: startOfWeek) else {
            return nil
        }

        var components = cal.dateComponents([.year, .month, .day], from: dayDate)
        components.hour = hour
        components.minute = minute
        components.second = 0
        components.timeZone = timeZone

        return cal.date(from: components)
    }

    // Menu bar display text for the next spawn
    var menuBarText: String {
        guard let next = nextSpawn else { return "No spawns" }
        return next.countdownText
    }

    var menuBarBossName: String {
        guard let next = nextSpawn else { return "" }
        return next.spawn.bossNames
    }
}
