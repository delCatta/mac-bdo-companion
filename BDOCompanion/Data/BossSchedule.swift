import Foundation

// Schedule data based on Dec 24 2025 restructure + March 2026 DST adjustments.
// Cross-referenced with mmotimer.com and official Pearl Abyss patch notes.
// Times are in the region's local timezone.
// NA = America/Los_Angeles (PT), EU = Europe/Berlin (CET/CEST)
//
// LOML bosses spawn alongside regular bosses (separate from "max 2" cap).
// Saturday evening has no 20:15/21:15 spawns (Node/Conquest Wars).

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
        // Monday
        s([.karanda],                              .monday,    0, 0),
        s([.kzarka],                               .monday,    3, 0),
        s([.kzarka, .uturi],                       .monday,    7, 0),
        s([.offinTett],                            .monday,   10, 0),
        s([.garmoth, .goldenPigKing],              .monday,   12, 0),
        s([.kutum, .bulgasal],                     .monday,   14, 0),
        s([.nouver, .bulgasal, .goldenPigKing],    .monday,   17, 0),
        s([.kzarka, .sangoon],                     .monday,   20, 15),
        s([.garmoth, .uturi],                      .monday,   21, 15),
        s([.karanda, .sangoon],                    .monday,   22, 15),

        // Tuesday
        s([.kutum],                                .tuesday,   0, 0),
        s([.kzarka],                               .tuesday,   3, 0),
        s([.nouver],                               .tuesday,   7, 0),
        s([.kutum],                                .tuesday,  10, 0),
        s([.garmoth, .goldenPigKing],              .tuesday,  12, 0),
        s([.nouver, .bulgasal],                    .tuesday,  14, 0),
        s([.karanda],                              .tuesday,  17, 0),
        s([.quint, .muraka, .bulgasal],            .tuesday,  20, 15),
        s([.garmoth, .sangoon],                    .tuesday,  21, 15),
        s([.kzarka, .kutum, .uturi],               .tuesday,  22, 15),

        // Wednesday
        s([.karanda],                              .wednesday, 0, 0),
        s([.kzarka],                               .wednesday, 3, 0),
        s([.karanda],                              .wednesday, 7, 0),
        s([.nouver],                               .wednesday,10, 0),
        s([.garmoth, .goldenPigKing],              .wednesday,12, 0),
        s([.kutum, .offinTett, .bulgasal],         .wednesday,14, 0),
        s([.vell, .sangoon],                       .wednesday,17, 0),
        s([.karanda, .kzarka, .uturi],             .wednesday,20, 15),
        s([.garmoth],                              .wednesday,21, 15),
        s([.nouver, .goldenPigKing],               .wednesday,22, 15),

        // Thursday
        s([.kutum],                                .thursday,  0, 0),
        s([.nouver, .sangoon],                     .thursday, 10, 0),
        s([.garmoth, .uturi],                      .thursday, 12, 0),
        s([.kzarka, .sangoon, .bulgasal],          .thursday, 14, 0),
        s([.kutum, .bulgasal],                     .thursday, 17, 0),
        s([.quint, .muraka, .uturi],               .thursday, 20, 15),
        s([.garmoth, .goldenPigKing],              .thursday, 21, 15),
        s([.karanda, .kzarka, .sangoon],           .thursday, 22, 15),

        // Friday
        s([.nouver],                               .friday,    0, 0),
        s([.karanda],                              .friday,    3, 0),
        s([.kutum],                                .friday,    7, 0),
        s([.karanda],                              .friday,   10, 0),
        s([.garmoth, .bulgasal],                   .friday,   12, 0),
        s([.nouver, .uturi, .goldenPigKing],       .friday,   14, 0),
        s([.kzarka, .bulgasal],                    .friday,   17, 0),
        s([.kzarka, .kutum],                       .friday,   20, 15),
        s([.garmoth],                              .friday,   21, 15),
        s([.karanda, .goldenPigKing],              .friday,   22, 15),

        // Saturday
        s([.offinTett, .uturi],                    .saturday,  0, 0),
        s([.nouver],                               .saturday,  3, 0),
        s([.kutum],                                .saturday,  7, 0),
        s([.nouver, .sangoon],                     .saturday, 10, 0),
        s([.garmoth, .goldenPigKing, .uturi],      .saturday, 12, 0),
        s([.bulgasal, .goldenPigKing],             .saturday, 14, 0),
        s([.karanda, .kzarka],                     .saturday, 17, 0),
        // No 20:15/21:15 spawns (Node/Conquest Wars)
        s([.nouver, .kutum, .sangoon],             .saturday, 22, 15),

        // Sunday
        s([.kzarka, .uturi],                       .sunday,    0, 0),
        s([.kutum],                                .sunday,    3, 0),
        s([.nouver],                               .sunday,    7, 0),
        s([.kzarka, .sangoon, .goldenPigKing],     .sunday,   10, 0),
        s([.garmoth],                              .sunday,   12, 0),
        s([.vell],                                 .sunday,   14, 0),
        s([.kzarka, .sangoon],                     .sunday,   17, 0),
        s([.garmoth, .bulgasal],                   .sunday,   17, 15),
        s([.kzarka, .nouver, .uturi],              .sunday,   20, 15),
        s([.garmoth, .goldenPigKing],              .sunday,   21, 15),
        s([.karanda, .kutum, .sangoon],            .sunday,   22, 15),
    ]

    // MARK: - EU Schedule (Times in CET / Europe/Berlin)

    private static let euSchedule: [BossSpawn] = [
        // Monday
        s([.karanda, .kutum, .uturi],              .monday,    0, 15),
        s([.karanda, .bulgasal],                   .monday,    2, 0),
        s([.kzarka],                               .monday,    5, 0),
        s([.kzarka],                               .monday,    9, 0),
        s([.offinTett],                            .monday,   12, 0),
        s([.garmoth],                              .monday,   14, 0),
        s([.kutum, .uturi],                        .monday,   16, 0),
        s([.nouver, .goldenPigKing, .bulgasal],    .monday,   19, 0),
        s([.garmoth],                              .monday,   19, 15),
        s([.kzarka, .sangoon, .uturi],             .monday,   22, 15),
        s([.garmoth],                              .monday,   23, 15),

        // Tuesday
        s([.karanda, .goldenPigKing],              .tuesday,   0, 15),
        s([.kutum, .sangoon],                      .tuesday,   2, 0),
        s([.kzarka],                               .tuesday,   5, 0),
        s([.nouver],                               .tuesday,   9, 0),
        s([.kutum],                                .tuesday,  12, 0),
        s([.garmoth],                              .tuesday,  14, 0),
        s([.nouver, .goldenPigKing],               .tuesday,  16, 0),
        s([.karanda, .bulgasal, .uturi],           .tuesday,  19, 0),
        s([.quint, .muraka, .goldenPigKing, .sangoon], .tuesday, 22, 15),
        s([.garmoth],                              .tuesday,  23, 15),

        // Wednesday
        s([.kzarka, .kutum, .bulgasal],            .wednesday, 0, 15),
        s([.karanda, .goldenPigKing],              .wednesday, 2, 0),
        s([.kzarka],                               .wednesday, 5, 0),
        s([.karanda],                              .wednesday, 9, 0),
        s([.nouver],                               .wednesday,12, 0),
        s([.garmoth],                              .wednesday,14, 0),
        s([.kutum, .offinTett, .bulgasal],         .wednesday,16, 0),
        s([.vell],                                 .wednesday,19, 0),
        s([.karanda, .kzarka, .sangoon, .uturi],   .wednesday,22, 15),
        s([.garmoth],                              .wednesday,23, 15),

        // Thursday
        s([.nouver, .bulgasal],                    .thursday,  0, 15),
        s([.kutum, .sangoon],                      .thursday,  2, 0),
        s([.nouver],                               .thursday,  5, 0),
        s([.kutum],                                .thursday,  9, 0),
        s([.garmoth],                              .thursday, 14, 0),
        s([.kzarka, .uturi],                       .thursday, 16, 0),
        s([.kutum, .sangoon, .bulgasal],           .thursday, 19, 0),
        s([.quint, .muraka, .goldenPigKing, .uturi], .thursday, 22, 15),
        s([.garmoth],                              .thursday, 23, 15),

        // Friday
        s([.karanda, .kzarka, .sangoon],           .friday,    0, 15),
        s([.nouver, .bulgasal],                    .friday,    2, 0),
        s([.karanda],                              .friday,    5, 0),
        s([.kutum],                                .friday,    9, 0),
        s([.karanda],                              .friday,   12, 0),
        s([.garmoth],                              .friday,   14, 0),
        s([.nouver, .uturi],                       .friday,   16, 0),
        s([.kzarka, .goldenPigKing],               .friday,   19, 0),
        s([.kzarka, .kutum, .bulgasal, .uturi],    .friday,   22, 15),
        s([.garmoth],                              .friday,   23, 15),

        // Saturday
        s([.karanda, .goldenPigKing, .sangoon],    .saturday,  0, 15),
        s([.offinTett, .goldenPigKing, .bulgasal], .saturday,  2, 0),
        s([.nouver],                               .saturday,  5, 0),
        s([.kutum],                                .saturday,  9, 0),
        s([.nouver],                               .saturday, 12, 0),
        s([.garmoth],                              .saturday, 14, 0),
        s([.uturi, .goldenPigKing],                .saturday, 16, 0),
        s([.karanda, .kzarka, .bulgasal, .sangoon], .saturday, 19, 0),
        // No 22:15/23:15 spawns (Node/Conquest Wars)

        // Sunday
        s([.nouver, .kutum, .goldenPigKing, .uturi], .sunday,  0, 15),
        s([.kzarka, .sangoon, .bulgasal],          .sunday,    2, 0),
        s([.kutum],                                .sunday,    5, 0),
        s([.nouver],                               .sunday,    9, 0),
        s([.kzarka],                               .sunday,   12, 0),
        s([.garmoth],                              .sunday,   14, 0),
        s([.vell],                                 .sunday,   16, 0),
        s([.kzarka, .nouver, .goldenPigKing, .sangoon], .sunday, 19, 0),
        s([.garmoth],                              .sunday,   22, 15),
        s([.karanda, .kutum, .uturi],              .sunday,   23, 15),
    ]

    // MARK: - SEA/SA (placeholders, mirror NA)

    private static let seaSchedule: [BossSpawn] = naSchedule
    private static let saSchedule: [BossSpawn] = naSchedule

    // Helper to reduce verbosity
    private static func s(_ bosses: [Boss], _ day: DayOfWeek, _ h: Int, _ m: Int) -> BossSpawn {
        BossSpawn(bosses: bosses, dayOfWeek: day, hour: h, minute: m)
    }
}
