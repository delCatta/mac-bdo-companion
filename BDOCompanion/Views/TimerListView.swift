import SwiftUI

struct TimerListView: View {
    @Bindable var engine: TimerEngine
    @AppStorage("showCountdownInMenuBar") private var showCountdownInMenuBar = true
    @State private var showSettings = false

    private var customTimerStore: CustomTimerStore {
        engine.customTimerStore
    }

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
                #if DEBUG
                Text("BDO Companion (DEV)")
                    .font(.headline)
                #else
                Text("BDO Companion")
                    .font(.headline)
                #endif
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
                                EventRowView(spawn: spawn)
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
        var result: [String: [UpcomingSpawn]] = [:]
        let sortedSpawns = engine.upcomingSpawns

        let byCategory = Dictionary(grouping: sortedSpawns, by: \.category)
        let sortedCategories = byCategory.keys.sorted { $0.sortOrder < $1.sortOrder }

        for category in sortedCategories {
            guard let spawns = byCategory[category] else { continue }
            let categoryPrefix = "\(category.sortOrder)-\(category.displayName)"

            let activeSpawns = spawns.filter(\.isActive)
            let futureSpawns = spawns.filter { !$0.isActive }

            for spawn in activeSpawns {
                result["\(categoryPrefix) · 0-Active Now", default: []].append(spawn)
            }

            for (index, spawn) in futureSpawns.enumerated() {
                let key: String
                if index == 0 {
                    key = "\(categoryPrefix) · 1-Next Up"
                } else {
                    let label = spawn.groupLabel
                    switch label {
                    case "Today": key = "\(categoryPrefix) · 2-Today"
                    case "Tomorrow": key = "\(categoryPrefix) · 3-Tomorrow"
                    default: key = "\(categoryPrefix) · 4-\(label)"
                    }
                }
                result[key, default: []].append(spawn)
            }
        }

        return result
    }
}
