import AppKit
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

    func playAlertSound(_ sound: AlertSound) {
        guard let url = Bundle.main.url(forResource: sound.filename, withExtension: "aiff") else {
            NSSound.beep()
            return
        }
        NSSound(contentsOf: url, byReference: true)?.play()
    }

    func scheduleNotifications(
        for spawns: [UpcomingSpawn],
        alertMinutesBefore: Int,
        progressive: Bool = false
    ) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized ||
                  settings.authorizationStatus == .provisional else {
                return
            }

            center.removeAllPendingNotificationRequests()

            let alertTimes = progressive
                ? Self.progressiveIntervals(for: alertMinutesBefore)
                : [alertMinutesBefore]

            let now = Date()
            let cutoff = now.addingTimeInterval(24 * 3600)
            let toSchedule = spawns
                .filter { $0.date < cutoff }
                .prefix(50)

            for spawn in toSchedule {
                for minutes in alertTimes {
                    let fireDate = spawn.date.addingTimeInterval(-TimeInterval(minutes * 60))
                    let interval = fireDate.timeIntervalSince(now)
                    guard interval > 0 else { continue }

                    let content = UNMutableNotificationContent()
                    content.title = "Boss Spawning Soon"
                    content.body = "\(spawn.spawn.bossNames) in \(minutes) minute\(minutes == 1 ? "" : "s")"
                    content.sound = .default

                    let trigger = UNTimeIntervalNotificationTrigger(
                        timeInterval: interval,
                        repeats: false
                    )

                    let id = "boss-\(spawn.spawn.dayOfWeek.rawValue)-\(spawn.spawn.hour)-\(spawn.spawn.minute)-\(minutes)"
                    let request = UNNotificationRequest(
                        identifier: id,
                        content: content,
                        trigger: trigger
                    )

                    center.add(request)
                }
            }
        }
    }

    static func progressiveIntervals(for baseMinutes: Int) -> [Int] {
        switch baseMinutes {
        case 5:  return [5, 3, 1]
        case 10: return [10, 5, 1]
        case 15: return [15, 10, 5, 3, 1]
        case 30: return [30, 20, 10, 5, 2]
        default: return [baseMinutes]
        }
    }
}
