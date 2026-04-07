import SwiftUI

struct MenuBarLabel: View {
    let bossName: String
    let countdown: String
    let showCountdown: Bool

    var body: some View {
        if showCountdown && !countdown.isEmpty {
            Label("\(bossName) \u{00B7} \(countdown)", systemImage: "shield.fill")
                .monospacedDigit()
        } else {
            Image(systemName: "shield.fill")
        }
    }
}
