import SwiftUI

@main
struct BDOCompanionApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var engine = BossTimerEngine()
    @AppStorage("showCountdownInMenuBar") private var showCountdownInMenuBar = true
    @AppStorage("selectedRegion") private var selectedRegionRaw = "na"
    @AppStorage("alertMinutesBefore") private var alertMinutesBefore = 10
    @AppStorage("trackedBossesData") private var trackedBossesData = Data()

    var body: some Scene {
        MenuBarExtra(engine.menuBarText, systemImage: "shield.fill") {
            BossListView(engine: engine)
        }
        .menuBarExtraStyle(.window)
    }

    init() {
        // Load persisted settings into engine
        let regionRaw = UserDefaults.standard.string(forKey: "selectedRegion") ?? "na"
        if let region = Region(rawValue: regionRaw) {
            _engine = State(initialValue: {
                let e = BossTimerEngine()
                e.selectedRegion = region
                if let data = UserDefaults.standard.data(forKey: "trackedBossesData"),
                   let bosses = try? JSONDecoder().decode(Set<Boss>.self, from: data) {
                    e.trackedBosses = bosses
                }
                return e
            }())
        }

        // Schedule initial notifications
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [engine] in
            let minutes = UserDefaults.standard.integer(forKey: "alertMinutesBefore")
            NotificationService.shared.scheduleNotifications(
                for: engine.upcomingSpawns,
                alertMinutesBefore: minutes > 0 ? minutes : 10
            )
        }
    }
}
