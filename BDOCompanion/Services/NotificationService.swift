import Foundation
@preconcurrency import UserNotifications

final class NotificationService: @unchecked Sendable {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if granted {
                        print("Notification permission granted")
                    } else if let error {
                        print("Notification permission error: \(error)")
                    } else {
                        print("Notification permission denied")
                    }
                }
            case .denied:
                print("Notifications denied. Enable in System Settings > Notifications > BDO Companion")
            case .authorized, .provisional, .ephemeral:
                break
            @unknown default:
                break
            }
        }
    }

    func sendTestNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Boss Spawning Soon"
        content.body = "This is a test alert"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "test-alert",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        center.add(request)
    }

    func scheduleNotifications(
        for spawns: [UpcomingSpawn],
        alertMinutesBefore: Int
    ) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized ||
                  settings.authorizationStatus == .provisional else {
                return
            }

            center.removeAllPendingNotificationRequests()

            let alertInterval = TimeInterval(alertMinutesBefore * 60)
            let now = Date()
            let cutoff = now.addingTimeInterval(24 * 3600)
            let toSchedule = spawns
                .filter { $0.date < cutoff }
                .prefix(50)

            for spawn in toSchedule {
                let fireDate = spawn.date.addingTimeInterval(-alertInterval)
                let interval = fireDate.timeIntervalSince(now)
                guard interval > 0 else { continue }

                let content = UNMutableNotificationContent()
                content.title = "Boss Spawning Soon"
                content.body = "\(spawn.spawn.bossNames) in \(alertMinutesBefore) minutes"
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: interval,
                    repeats: false
                )

                let request = UNNotificationRequest(
                    identifier: "boss-\(spawn.spawn.dayOfWeek.rawValue)-\(spawn.spawn.hour)-\(spawn.spawn.minute)",
                    content: content,
                    trigger: trigger
                )

                center.add(request)
            }
        }
    }
}
