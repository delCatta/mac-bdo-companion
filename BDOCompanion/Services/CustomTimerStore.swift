import Foundation
import Observation

@MainActor
@Observable
final class CustomTimerStore {
    private static let storageKey = "customTimersData"

    var customTimers: [CustomTimer] = []

    var onDidChange: (() -> Void)?

    init(initial: [CustomTimer] = []) {
        if initial.isEmpty {
            load()
        } else {
            customTimers = initial
        }
    }

    func add(_ timer: CustomTimer) {
        customTimers.append(timer)
        save()
    }

    func update(_ timer: CustomTimer) {
        guard let index = customTimers.firstIndex(where: { $0.id == timer.id }) else { return }
        customTimers[index] = timer
        save()
    }

    func delete(_ timer: CustomTimer) {
        customTimers.removeAll { $0.id == timer.id }
        save()
    }

    func delete(at offsets: IndexSet) {
        customTimers.remove(atOffsets: offsets)
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(customTimers) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
        onDidChange?()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let timers = try? JSONDecoder().decode([CustomTimer].self, from: data) else {
            return
        }
        customTimers = timers
    }
}
