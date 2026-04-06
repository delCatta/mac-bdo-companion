import SwiftUI

struct BossRowView: View {
    let spawn: UpcomingSpawn

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: spawn.spawn.bosses.first?.iconSymbol ?? "questionmark")
                    .foregroundStyle(urgencyColor)
                    .frame(width: 16)

                VStack(alignment: .leading, spacing: 1) {
                    Text(spawn.spawn.bossNames)
                        .font(.system(.body, weight: .medium))

                    Text(spawnTimeText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text(spawn.countdownText)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(urgencyColor)
        }
        .padding(.vertical, 2)
    }

    private var urgencyColor: Color {
        switch spawn.urgency {
        case .imminent: .red
        case .soon: .yellow
        case .normal: .primary
        }
    }

    private var spawnTimeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE h:mm a"
        return formatter.string(from: spawn.date)
    }
}
