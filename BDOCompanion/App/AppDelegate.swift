import AppKit
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self
        NotificationService.shared.requestPermission()
        installSoundFiles()
    }

    private func installSoundFiles() {
        let soundsDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Sounds")
        try? FileManager.default.createDirectory(at: soundsDir, withIntermediateDirectories: true)

        for sound in AlertSound.allCases {
            let filename = sound.filename + ".aiff"
            guard let bundleURL = Bundle.main.url(forResource: sound.filename, withExtension: "aiff") else { continue }
            let destURL = soundsDir.appendingPathComponent(filename)
            try? FileManager.default.removeItem(at: destURL)
            try? FileManager.default.copyItem(at: bundleURL, to: destURL)
        }
    }

    // Show notifications even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
