import SwiftUI

@main
struct BDOCompanionApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var engine = TimerEngine()
    @AppStorage("selectedRegion") private var selectedRegionRaw = "na"
    @AppStorage("alertMinutesBefore") private var alertMinutesBefore = 10
    @AppStorage("trackedBossesData") private var trackedBossesData = Data()

    var body: some Scene {
        MenuBarExtra {
            TimerListView(engine: engine)
        } label: {
            let text = engine.menuBarText
            if text.isEmpty {
                #if DEBUG
                Text("BDO Companion (DEV)")
                #else
                Text("BDO Companion")
                #endif
            } else {
                #if DEBUG
                Text("DEV · \(text)").monospacedDigit()
                #else
                Text(text).monospacedDigit()
                #endif
            }
        }
        .menuBarExtraStyle(.window)
    }

    init() {
        // Load persisted settings into engine
        let regionRaw = UserDefaults.standard.string(forKey: "selectedRegion") ?? "na"
        if let region = Region(rawValue: regionRaw) {
            _engine = State(initialValue: {
                var customTimers: [CustomTimer] = []
                if let data = UserDefaults.standard.data(forKey: "customTimersData"),
                   let decoded = try? JSONDecoder().decode([CustomTimer].self, from: data) {
                    customTimers = decoded
                }
                let store = CustomTimerStore(initial: customTimers)
                let e = TimerEngine(customTimerStore: store)
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
            let progressive = UserDefaults.standard.bool(forKey: "progressiveAlerts")
            let bossSoundRaw = UserDefaults.standard.string(forKey: "bossAlertSound")
                ?? UserDefaults.standard.string(forKey: "alertSound")
                ?? AlertSound.bossRoar.rawValue
            let nodeWarSoundRaw = UserDefaults.standard.string(forKey: "nodeWarAlertSound")
                ?? UserDefaults.standard.string(forKey: "alertSound")
                ?? AlertSound.warHorn.rawValue
            let bossSound = AlertSound(rawValue: bossSoundRaw) ?? .bossRoar
            let nodeWarSound = AlertSound(rawValue: nodeWarSoundRaw) ?? .warHorn
            NotificationService.shared.scheduleNotifications(
                for: engine.upcomingSpawns,
                alertMinutesBefore: minutes > 0 ? minutes : 10,
                progressive: progressive,
                bossAlertSound: bossSound,
                nodeWarAlertSound: nodeWarSound
            )
        }
    }
}
