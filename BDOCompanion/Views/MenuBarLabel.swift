import SwiftUI

struct MenuBarLabel: View {
    let bossName: String
    let countdown: String
    let showCountdown: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "shield.fill")
            if showCountdown && !countdown.isEmpty {
                Text(countdown)
                    .monospacedDigit()
            }
        }
    }
}
