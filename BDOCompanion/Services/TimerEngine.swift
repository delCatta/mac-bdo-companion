import Foundation
import Observation

@MainActor
@Observable
final class TimerEngine {
    var upcomingSpawns: [UpcomingSpawn] = []
    var nextSpawn: UpcomingSpawn? { upcomingSpawns.first }

    private var timer: Timer?

    var selectedRegion: Region = .na {
        didSet { recompute() }
    }

    var trackedBosses: Set<Boss> = Set(Boss.allCases) {
        didSet { recompute() }
    }

    let customTimerStore: CustomTimerStore

    init(customTimerStore: CustomTimerStore = CustomTimerStore()) {
        self.customTimerStore = customTimerStore
        customTimerStore.onDidChange = { [weak self] in
            self?.recompute()
        }
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

        var needsRecompute = false
        var updated: [UpcomingSpawn] = []
        for spawn in upcomingSpawns {
            let remaining = spawn.date.timeIntervalSince(now)
            if remaining <= -300 {
                needsRecompute = true
                continue
            }
            if let bossSpawn = spawn.spawn {
                updated.append(UpcomingSpawn(
                    spawn: bossSpawn,
                    date: spawn.date,
                    timeRemaining: remaining,
                    category: spawn.category
                ))
            } else {
                updated.append(UpcomingSpawn(
                    displayName: spawn.displayName,
                    date: spawn.date,
                    timeRemaining: remaining,
                    category: spawn.category
                ))
            }
        }

        if needsRecompute {
            recompute()
        } else {
            upcomingSpawns = updated
        }
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
                    guard remaining > -300 else { continue }

                    // Skip event spawns past their end date
                    if let activeUntil = spawn.activeUntil, date > activeUntil {
                        continue
                    }

                    let filteredSpawn = BossSpawn(
                        bosses: relevantBosses,
                        dayOfWeek: spawn.dayOfWeek,
                        hour: spawn.hour,
                        minute: spawn.minute
                    )

                    upcoming.append(UpcomingSpawn(
                        spawn: filteredSpawn,
                        date: date,
                        timeRemaining: remaining,
                        category: .boss
                    ))
                }
            }
        }

        // Node war spawns
        for entry in NodeWarSchedule.entries(for: region) {
            for weekOffset in 0...1 {
                if let date = nextDate(
                    for: entry.dayOfWeek,
                    hour: entry.hour,
                    minute: entry.minute,
                    in: region.timeZone,
                    weekOffset: weekOffset,
                    relativeTo: now,
                    calendar: calendar
                ) {
                    let remaining = date.timeIntervalSince(now)
                    guard remaining > -300 else { continue }

                    upcoming.append(UpcomingSpawn(
                        displayName: "\(entry.tier) Node War",
                        date: date,
                        timeRemaining: remaining,
                        category: .nodeWar
                    ))
                }
            }
        }

        // Custom timer spawns
        for timer in customTimerStore.customTimers where timer.isEnabled {
            for weekOffset in 0...1 {
                if let date = nextDate(
                    for: timer.dayOfWeek,
                    hour: timer.hour,
                    minute: timer.minute,
                    in: region.timeZone,
                    weekOffset: weekOffset,
                    relativeTo: now,
                    calendar: calendar
                ) {
                    let remaining = date.timeIntervalSince(now)
                    guard remaining > -300 else { continue }

                    upcoming.append(UpcomingSpawn(
                        displayName: timer.name,
                        date: date,
                        timeRemaining: remaining,
                        category: .custom(id: timer.id.uuidString)
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
        cal.firstWeekday = 1 // Force Sunday-start weeks to match DayOfWeek enum

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

    var menuBarText: String {
        let activeSpawn = upcomingSpawns.first(where: \.isActive)
        guard let target = activeSpawn ?? nextSpawn else { return "" }
        let name = target.spawn?.bosses.first?.displayName ?? target.displayName
        return "\(name) \u{00B7} \(target.countdownText)"
    }
}
