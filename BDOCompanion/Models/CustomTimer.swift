import Foundation

struct CustomTimer: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var dayOfWeek: DayOfWeek
    var hour: Int
    var minute: Int
    var alertSound: AlertSound
    var isEnabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        dayOfWeek: DayOfWeek,
        hour: Int,
        minute: Int,
        alertSound: AlertSound = .bossRoar,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.dayOfWeek = dayOfWeek
        self.hour = hour
        self.minute = minute
        self.alertSound = alertSound
        self.isEnabled = isEnabled
    }
}
