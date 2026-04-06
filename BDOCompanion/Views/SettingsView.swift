import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @Bindable var engine: BossTimerEngine
    @AppStorage("selectedRegion") private var selectedRegionRaw = "na"
    @AppStorage("alertMinutesBefore") private var alertMinutesBefore = 10
    @AppStorage("showCountdownInMenuBar") private var showCountdownInMenuBar = true
    @AppStorage("trackedBossesData") private var trackedBossesData = Data()
    @State private var launchAtLogin = false

    private let alertOptions = [5, 10, 15, 30]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)

            regionSection
            alertSection
            displaySection
            bossTogglesSection
            launchAtLoginSection
        }
        .padding(16)
        .frame(width: 300)
        .onAppear { loadState() }
    }

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

    private var alertSection: some View {
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
    }

    private var displaySection: some View {
        Toggle("Show countdown in menu bar", isOn: $showCountdownInMenuBar)
            .font(.subheadline)
    }

    private var bossTogglesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tracked Bosses")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(BossCategory.allCases, id: \.rawValue) { category in
                let bosses = Boss.allCases.filter { $0.category == category }
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    ForEach(bosses) { boss in
                        Toggle(boss.displayName, isOn: bossBinding(for: boss))
                            .font(.subheadline)
                            .toggleStyle(.checkbox)
                    }
                }
            }
        }
    }

    private var launchAtLoginSection: some View {
        Toggle("Launch at login", isOn: $launchAtLogin)
            .font(.subheadline)
            .onChange(of: launchAtLogin) { _, newValue in
                setLaunchAtLogin(newValue)
            }
    }

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
            engine.trackedBosses = bosses
        }
    }

    private func saveTrackedBosses() {
        if let data = try? JSONEncoder().encode(engine.trackedBosses) {
            trackedBossesData = data
        }
    }

    private func rescheduleNotifications() {
        NotificationService.shared.scheduleNotifications(
            for: engine.upcomingSpawns,
            alertMinutesBefore: alertMinutesBefore
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
