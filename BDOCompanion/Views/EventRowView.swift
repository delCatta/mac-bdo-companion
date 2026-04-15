import SwiftUI

struct EventRowView: View {
    let spawn: UpcomingSpawn
    @State private var glowPulsing = false

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: spawn.spawn?.bosses.first?.iconSymbol ?? "flag.fill")
                    .foregroundStyle(urgencyColor)
                    .frame(width: 16)

                VStack(alignment: .leading, spacing: 1) {
                    Text(spawn.displayName)
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
        .shadow(
            color: spawn.urgency == .active ? .green.opacity(glowPulsing ? 0.8 : 0.3) : .clear,
            radius: 4
        )
        .animation(
            spawn.urgency == .active
                ? .easeInOut(duration: 1).repeatForever(autoreverses: true)
                : .default,
            value: glowPulsing
        )
        .onAppear {
            if spawn.urgency == .active {
                glowPulsing = true
            }
        }
        .onChange(of: spawn.urgency) { _, newValue in
            glowPulsing = newValue == .active
        }
    }

    private var urgencyColor: Color {
        switch spawn.urgency {
        case .active: .green
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
