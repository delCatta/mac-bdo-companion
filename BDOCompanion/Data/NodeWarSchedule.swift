import Foundation

enum NodeWarSchedule {
    static func entries(for region: Region) -> [NodeWarEntry] {
        switch region {
        case .na: return naSchedule
        case .eu: return euSchedule
        case .sea: return seaSchedule
        case .sa: return saSchedule
        }
    }

    // MARK: - NA Schedule (Times in PT / America/Los_Angeles)
    // Node wars: Sun–Thu 9:00 PM PT, tiers rotate by day
    // Saturday: Conquest War 9:00 PM PT
    // Friday: no node war

    private static let naSchedule: [NodeWarEntry] = [
        n("T1",       .sunday,    21, 0),
        n("T2",       .monday,    21, 0),
        n("T3",       .tuesday,   21, 0),
        n("T1",       .wednesday, 21, 0),
        n("T2",       .thursday,  21, 0),
        n("Conquest", .saturday,  21, 0),
    ]

    // MARK: - EU Schedule (Times in CET / Europe/Berlin)
    // TODO: Verify against real EU schedule

    private static let euSchedule: [NodeWarEntry] = naSchedule

    // MARK: - SEA/SA (placeholders)

    private static let seaSchedule: [NodeWarEntry] = naSchedule
    private static let saSchedule: [NodeWarEntry] = naSchedule

    // MARK: - Helpers

    private static func n(_ tier: String, _ day: DayOfWeek, _ h: Int, _ m: Int) -> NodeWarEntry {
        NodeWarEntry(tier: tier, dayOfWeek: day, hour: h, minute: m)
    }
}
