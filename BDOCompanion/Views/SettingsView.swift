import SwiftUI
import ServiceManagement

enum SettingsTab: String, CaseIterable {
    case bosses = "Bosses"
    case soundAlerts = "Sound & Alerts"
    case customTimers = "Timers"
}

struct SettingsView: View {
    @Bindable var engine: TimerEngine
    @AppStorage("selectedRegion") private var selectedRegionRaw = "na"
    @AppStorage("alertMinutesBefore") private var alertMinutesBefore = 10
    @AppStorage("progressiveAlerts") private var progressiveAlerts = false
@AppStorage("bossAlertSound") private var bossAlertSoundRaw = AlertSound.bossRoar.rawValue
    @AppStorage("nodeWarAlertSound") private var nodeWarAlertSoundRaw = AlertSound.bossRoar.rawValue
    @AppStorage("trackedBossesData") private var trackedBossesData = Data()
    @State private var launchAtLogin = false
    @State private var selectedTab: SettingsTab = .soundAlerts
    @State private var editingTimer: CustomTimer?
    @State private var isAddingTimer = false

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
        case .customTimers:
            customTimersTab
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

    private var selectedBossSound: AlertSound {
        AlertSound(rawValue: bossAlertSoundRaw) ?? .bossRoar
    }

    private var selectedNodeWarSound: AlertSound {
        AlertSound(rawValue: nodeWarAlertSoundRaw) ?? .bossRoar
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
                Text("Boss alert sound")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Picker("", selection: $bossAlertSoundRaw) {
                        ForEach(AlertSound.allCases) { sound in
                            Text(sound.displayName).tag(sound.rawValue)
                        }
                    }
                    .labelsHidden()
                    Button {
                        NotificationService.shared.playAlertSound(selectedBossSound)
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .controlSize(.small)
                }
                .onChange(of: bossAlertSoundRaw) { _, _ in
                    rescheduleNotifications()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Node war alert sound")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Picker("", selection: $nodeWarAlertSoundRaw) {
                        ForEach(AlertSound.allCases) { sound in
                            Text(sound.displayName).tag(sound.rawValue)
                        }
                    }
                    .labelsHidden()
                    Button {
                        NotificationService.shared.playAlertSound(selectedNodeWarSound)
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .controlSize(.small)
                }
                .onChange(of: nodeWarAlertSoundRaw) { _, _ in
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

    // MARK: - Custom Timers Tab

    private var customTimersTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if engine.customTimerStore.customTimers.isEmpty && !isAddingTimer {
                    Text("No custom timers yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }

                ForEach(engine.customTimerStore.customTimers) { timer in
                    if editingTimer?.id == timer.id {
                        customTimerForm(editing: timer)
                    } else {
                        customTimerRow(timer)
                    }
                }

                if isAddingTimer {
                    customTimerForm(editing: nil)
                }

                if !isAddingTimer && editingTimer == nil {
                    Button {
                        isAddingTimer = true
                    } label: {
                        Label("Add Timer", systemImage: "plus")
                    }
                    .controlSize(.small)
                }
            }
            .padding(16)
        }
    }

    private func customTimerRow(_ timer: CustomTimer) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(timer.name)
                    .font(.subheadline)
                Text("\(timer.dayOfWeek.shortName) \(String(format: "%02d:%02d", timer.hour, timer.minute))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { timer.isEnabled },
                set: { newValue in
                    var updated = timer
                    updated.isEnabled = newValue
                    engine.customTimerStore.update(updated)
                    rescheduleNotifications()
                }
            ))
            .toggleStyle(.checkbox)
            .labelsHidden()

            Button {
                editingTimer = timer
            } label: {
                Image(systemName: "pencil")
            }
            .buttonStyle(.borderless)
            .controlSize(.small)

            Button(role: .destructive) {
                engine.customTimerStore.delete(timer)
                rescheduleNotifications()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
            .controlSize(.small)
        }
    }

    @ViewBuilder
    private func customTimerForm(editing timer: CustomTimer?) -> some View {
        CustomTimerFormView(
            initial: timer,
            onSave: { saved in
                if timer != nil {
                    engine.customTimerStore.update(saved)
                } else {
                    engine.customTimerStore.add(saved)
                }
                editingTimer = nil
                isAddingTimer = false
                rescheduleNotifications()
            },
            onCancel: {
                editingTimer = nil
                isAddingTimer = false
            }
        )
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
            bossAlertSound: selectedBossSound,
            nodeWarAlertSound: selectedNodeWarSound
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

private struct CustomTimerFormView: View {
    let initial: CustomTimer?
    let onSave: (CustomTimer) -> Void
    let onCancel: () -> Void

    @State private var name: String
    @State private var dayOfWeek: DayOfWeek
    @State private var hour: Int
    @State private var minute: Int
    @State private var alertSoundRaw: String
    @State private var isEnabled: Bool

    init(initial: CustomTimer?, onSave: @escaping (CustomTimer) -> Void, onCancel: @escaping () -> Void) {
        self.initial = initial
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: initial?.name ?? "")
        _dayOfWeek = State(initialValue: initial?.dayOfWeek ?? .sunday)
        _hour = State(initialValue: initial?.hour ?? 12)
        _minute = State(initialValue: initial?.minute ?? 0)
        _alertSoundRaw = State(initialValue: initial?.alertSound.rawValue ?? AlertSound.bossRoar.rawValue)
        _isEnabled = State(initialValue: initial?.isEnabled ?? true)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Timer name", text: $name)
                .textFieldStyle(.roundedBorder)
                .font(.subheadline)

            HStack {
                Picker("Day", selection: $dayOfWeek) {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        Text(day.shortName).tag(day)
                    }
                }
                .labelsHidden()

                Picker("Hour", selection: $hour) {
                    ForEach(0..<24, id: \.self) { h in
                        Text(String(format: "%02d", h)).tag(h)
                    }
                }
                .labelsHidden()
                .frame(width: 60)

                Text(":")
                    .font(.subheadline)

                Picker("Minute", selection: $minute) {
                    ForEach(0..<60, id: \.self) { m in
                        Text(String(format: "%02d", m)).tag(m)
                    }
                }
                .labelsHidden()
                .frame(width: 60)
            }

            HStack {
                Text("Sound")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("", selection: $alertSoundRaw) {
                    ForEach(AlertSound.allCases) { sound in
                        Text(sound.displayName).tag(sound.rawValue)
                    }
                }
                .labelsHidden()
            }

            Toggle("Enabled", isOn: $isEnabled)
                .font(.subheadline)
                .toggleStyle(.checkbox)

            HStack {
                Spacer()
                Button("Cancel", action: onCancel)
                    .controlSize(.small)
                Button("Save") {
                    let timer = CustomTimer(
                        id: initial?.id ?? UUID(),
                        name: name.trimmingCharacters(in: .whitespaces),
                        dayOfWeek: dayOfWeek,
                        hour: hour,
                        minute: minute,
                        alertSound: AlertSound(rawValue: alertSoundRaw) ?? .bossRoar,
                        isEnabled: isEnabled
                    )
                    onSave(timer)
                }
                .controlSize(.small)
                .disabled(!canSave)
            }
        }
        .padding(8)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
