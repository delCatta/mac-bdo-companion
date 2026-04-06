import Foundation

// Schedule data from garmoth.com, converted to PT (America/Los_Angeles).
// Garmoth shows times in the viewer's local timezone. These were captured
// in CEST (UTC+2) and converted to PDT (UTC-7) = CEST - 9h.
//
// Last verified: April 6 2026

enum BossSchedule {
    static func spawns(for region: Region) -> [BossSpawn] {
        switch region {
        case .na: return naSchedule
        case .eu: return euSchedule
        case .sea: return seaSchedule
        case .sa: return saSchedule
        }
    }

    // MARK: - NA Schedule (Times in PT / America/Los_Angeles)

    private static let naSchedule: [BossSpawn] = [
        // Sunday
        s([.sangoon, .offinTett],              .sunday,    0, 0),
        s([.goldenPigKing, .kutum],            .sunday,   10, 0),
        s([.garmoth],                          .sunday,   12, 0),
        s([.vell],                             .sunday,   14, 0),
        s([.garmoth],                          .sunday,   17, 0),
        s([.uturi, .karanda],                  .sunday,   20, 15),
        s([.garmoth],                          .sunday,   21, 15),
        s([.bulgasal, .nouver],                .sunday,   22, 15),

        // Monday
        s([.goldenPigKing, .kzarka],           .monday,    0, 0),
        s([.uturi, .nouver],                   .monday,   10, 0),
        s([.garmoth],                          .monday,   12, 0),
        s([.sangoon, .karanda],                .monday,   17, 0),
        s([.goldenPigKing, .kutum],            .monday,   20, 15),
        s([.garmoth],                          .monday,   21, 15),
        s([.bulgasal, .offinTett],             .monday,   22, 15),

        // Tuesday
        s([.sangoon, .nouver],                 .tuesday,   0, 0),
        s([.goldenPigKing, .kutum],            .tuesday,  10, 0),
        s([.garmoth],                          .tuesday,  12, 0),
        s([.bulgasal, .kzarka],                .tuesday,  17, 0),
        s([.sangoon, .nouver],                 .tuesday,  20, 15),
        s([.garmoth],                          .tuesday,  21, 15),
        s([.uturi, .karanda],                  .tuesday,  22, 15),

        // Wednesday
        s([.goldenPigKing, .kutum],            .wednesday, 0, 0),
        s([.bulgasal, .nouver],                .wednesday,10, 0),
        s([.garmoth],                          .wednesday,12, 0),
        s([.vell],                             .wednesday,17, 0),
        s([.sangoon, .karanda],                .wednesday,20, 15),
        s([.garmoth],                          .wednesday,21, 15),
        s([.uturi, .kzarka],                   .wednesday,22, 15),

        // Thursday
        s([.bulgasal, .karanda],               .thursday,  0, 0),
        s([.sangoon, .kzarka],                 .thursday, 10, 0),
        s([.garmoth],                          .thursday, 12, 0),
        s([.quint, .muraka],                   .thursday, 14, 0),
        s([.uturi, .offinTett],                .thursday, 17, 0),
        s([.bulgasal, .kutum],                 .thursday, 20, 15),
        s([.garmoth],                          .thursday, 21, 15),
        s([.goldenPigKing, .nouver],           .thursday, 22, 15),

        // Friday
        s([.uturi, .kzarka],                   .friday,    0, 0),
        s([.bulgasal, .karanda],               .friday,   10, 0),
        s([.garmoth],                          .friday,   12, 0),
        s([.sangoon, .kutum],                  .friday,   14, 0),
        s([.goldenPigKing, .nouver],           .friday,   17, 0),
        s([.uturi, .kzarka],                   .friday,   20, 15),
        s([.garmoth],                          .friday,   21, 15),
        s([.sangoon, .karanda],                .friday,   22, 15),

        // Saturday
        s([.bulgasal, .nouver],                .saturday,  0, 0),
        s([.uturi, .kzarka],                   .saturday, 10, 0),
        s([.garmoth],                          .saturday, 12, 0),
        s([.quint, .muraka],                   .saturday, 17, 0),
        // No 20:15 or 21:15 (Node/Conquest Wars)
        s([.goldenPigKing, .kutum],            .saturday, 22, 15),
    ]

    // MARK: - EU Schedule (Times in CET / Europe/Berlin)
    // TODO: Verify against garmoth.com EU schedule

    private static let euSchedule: [BossSpawn] = naSchedule

    // MARK: - SEA/SA (placeholders)

    private static let seaSchedule: [BossSpawn] = naSchedule
    private static let saSchedule: [BossSpawn] = naSchedule

    // Helper to reduce verbosity
    private static func s(_ bosses: [Boss], _ day: DayOfWeek, _ h: Int, _ m: Int) -> BossSpawn {
        BossSpawn(bosses: bosses, dayOfWeek: day, hour: h, minute: m)
    }
}
