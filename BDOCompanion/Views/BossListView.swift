import SwiftUI

struct BossListView: View {
    @Bindable var engine: BossTimerEngine
    @AppStorage("showCountdownInMenuBar") private var showCountdownInMenuBar = true
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            spawnList
            Divider()
            footer
        }
        .frame(width: 320)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("BDO Companion")
                    .font(.headline)
                Text(engine.selectedRegion.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gear")
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showSettings) {
                SettingsView(engine: engine)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var spawnList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                let grouped = groupedSpawns
                ForEach(Array(grouped.keys.sorted()), id: \.self) { group in
                    if let spawns = grouped[group] {
                        Section {
                            ForEach(spawns) { spawn in
                                BossRowView(spawn: spawn)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                            }
                        } header: {
                            Text(group)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 12)
                                .padding(.top, 8)
                                .padding(.bottom, 2)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 400)
    }

    private var footer: some View {
        HStack {
            Spacer()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    private var groupedSpawns: [String: [UpcomingSpawn]] {
        // Use ordered grouping with section ordering: Next Up, Today, Tomorrow, then day names
        var result: [String: [UpcomingSpawn]] = [:]
        let sortedSpawns = engine.upcomingSpawns

        // Mark the first spawn as "Next Up"
        for (index, spawn) in sortedSpawns.enumerated() {
            let key: String
            if index == 0 {
                key = "0-Next Up"
            } else {
                let label = spawn.groupLabel
                switch label {
                case "Today": key = "1-Today"
                case "Tomorrow": key = "2-Tomorrow"
                default: key = "3-\(label)"
                }
            }
            result[key, default: []].append(spawn)
        }

        return result
    }
}
