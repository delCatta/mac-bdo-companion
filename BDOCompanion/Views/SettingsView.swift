import SwiftUI
import ServiceManagement

enum SettingsTab: String, CaseIterable {
    case bosses = "Bosses"
    case soundAlerts = "Sound & Alerts"
}

struct SettingsView: View {
    @Bindable var engine: BossTimerEngine
    @AppStorage("selectedRegion") private var selectedRegionRaw = "na"
    @AppStorage("alertMinutesBefore") private var alertMinutesBefore = 10
    @AppStorage("progressiveAlerts") private var progressiveAlerts = false
@AppStorage("alertSound") private var alertSoundRaw = AlertSound.bossRoar.rawValue
    @AppStorage("trackedBossesData") private var trackedBossesData = Data()
    @State private var launchAtLogin = false
    @State private var selectedTab: SettingsTab = .soundAlerts

    private let alertOptions = [5, 10, 15, 30]

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            tabContent
        }
        .frame(width: 300)
        .onAppear { loadState() }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
            }

            regionSection

            Picker("", selection: $selectedTab) {
                ForEach(SettingsTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
        }
        .padding(16)
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .bosses:
            bossesTab
        case .soundAlerts:
            soundAlertsTab
        }
    }

    // MARK: - Bosses Tab

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private var bossesTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(BossCategory.allCases, id: \.rawValue) { category in
                    let bosses = Boss.allCases.filter { $0.category == category }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.rawValue)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 4) {
                            ForEach(bosses) { boss in
                                Toggle(boss.displayName, isOn: bossBinding(for: boss))
                                    .font(.subheadline)
                                    .toggleStyle(.checkbox)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
    }

    // MARK: - Sound & Alerts Tab

    private var selectedAlertSound: AlertSound {
        AlertSound(rawValue: alertSoundRaw) ?? .bossRoar
    }

    private var soundAlertsTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Alert before spawn")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("", selection: $alertMinutesBefore) {
                    ForEach(alertOptions, id: \.self) { minutes in
                        Text("\(minutes) min").tag(minutes)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: alertMinutesBefore) { _, _ in
                    rescheduleNotifications()
                }
            }

            Toggle("Progressive alerts", isOn: $progressiveAlerts)
                .font(.subheadline)
                .onChange(of: progressiveAlerts) { _, _ in
                    rescheduleNotifications()
                }
            Text(progressiveAlertDescription)
                .font(.caption2)
                .foregroundStyle(.tertiary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Alert sound")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Picker("", selection: $alertSoundRaw) {
                        ForEach(AlertSound.allCases) { sound in
                            Text(sound.displayName).tag(sound.rawValue)
                        }
                    }
                    .labelsHidden()
                    Button {
                        NotificationService.shared.playAlertSound(selectedAlertSound)
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .controlSize(.small)
                }
                .onChange(of: alertSoundRaw) { _, _ in
                    rescheduleNotifications()
                }
            }

            Divider()

            Toggle("Launch at login", isOn: $launchAtLogin)
                .font(.subheadline)
                .onChange(of: launchAtLogin) { _, newValue in
                    setLaunchAtLogin(newValue)
                }

            Spacer()
        }
        .padding(16)
    }

    // MARK: - Region

    private var regionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Region")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker("", selection: $selectedRegionRaw) {
                ForEach(Region.allCases) { region in
                    Text(region.displayName).tag(region.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .onChange(of: selectedRegionRaw) { _, newValue in
                if let region = Region(rawValue: newValue) {
                    engine.selectedRegion = region
                    rescheduleNotifications()
                }
            }
        }
    }

    // MARK: - Helpers

    private func bossBinding(for boss: Boss) -> Binding<Bool> {
        Binding(
            get: { engine.trackedBosses.contains(boss) },
            set: { isTracked in
                if isTracked {
                    engine.trackedBosses.insert(boss)
                } else {
                    engine.trackedBosses.remove(boss)
                }
                saveTrackedBosses()
                rescheduleNotifications()
            }
        )
    }

    private func loadState() {
        if let region = Region(rawValue: selectedRegionRaw) {
            engine.selectedRegion = region
        }
        if let bosses = try? JSONDecoder().decode(Set<Boss>.self, from: trackedBossesData) {
            // Include any new bosses added since the set was last saved
            let newBosses = Set(Boss.allCases).subtracting(bosses)
            engine.trackedBosses = bosses.union(newBosses)
        }
    }

    private func saveTrackedBosses() {
        if let data = try? JSONEncoder().encode(engine.trackedBosses) {
            trackedBossesData = data
        }
    }

    private var progressiveAlertDescription: String {
        let intervals = NotificationService.progressiveIntervals(for: alertMinutesBefore)
        let formatted = intervals.map { "\($0)m" }.joined(separator: ", ")
        return progressiveAlerts ? "Alerts at: \(formatted)" : "Single alert at \(alertMinutesBefore)m"
    }

    private func rescheduleNotifications() {
        NotificationService.shared.scheduleNotifications(
            for: engine.upcomingSpawns,
            alertMinutesBefore: alertMinutesBefore,
            progressive: progressiveAlerts,
            alertSound: selectedAlertSound
        )
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Launch at login error: \(error)")
            }
        }
    }
}
