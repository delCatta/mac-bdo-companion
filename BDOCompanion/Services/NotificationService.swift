import Foundation
import UserNotifications

final class NotificationService: @unchecked Sendable {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func scheduleNotifications(
        for spawns: [UpcomingSpawn],
        alertMinutesBefore: Int
    ) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let alertInterval = TimeInterval(alertMinutesBefore * 60)

        // Schedule for next 24h of spawns, staying within 64-notification limit
        let cutoff = Date().addingTimeInterval(24 * 3600)
        let toSchedule = spawns
            .filter { $0.date < cutoff }
            .prefix(50)

        for spawn in toSchedule {
            let fireDate = spawn.date.addingTimeInterval(-alertInterval)
            guard fireDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Boss Spawning Soon"
            content.body = "\(spawn.spawn.bossNames) in \(alertMinutesBefore) minutes"
            content.sound = .default
            content.categoryIdentifier = "BOSS_ALERT"

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: fireDate.timeIntervalSinceNow,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: "boss-\(spawn.spawn.dayOfWeek.rawValue)-\(spawn.spawn.hour)-\(spawn.spawn.minute)",
                content: content,
                trigger: trigger
            )

            center.add(request) { error in
                if let error {
                    print("Failed to schedule notification: \(error)")
                }
            }
        }
    }
}
