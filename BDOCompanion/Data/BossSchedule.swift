import Foundation

// Schedule data based on official BDO world boss spawn times.
// Times are in the region's local timezone.
// NA = America/Los_Angeles (PT), EU = UTC
//
// Source: community schedules (Velia Inn, mmotimer, garmoth.com)
// Last verified: 2025
//
// Slots with multiple bosses means they share the time window.

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

    static let naSchedule: [BossSpawn] = [
        // Sunday
        BossSpawn(bosses: [.nouver],        dayOfWeek: .sunday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .sunday,    hour: 2,  minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .sunday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .sunday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .sunday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .sunday,    hour: 16, minute: 0),
        BossSpawn(bosses: [.vell],          dayOfWeek: .sunday,    hour: 16, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .sunday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .sunday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .sunday,    hour: 23, minute: 15),

        // Monday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .monday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .monday,    hour: 2,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .monday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .monday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .monday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .monday,    hour: 16, minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .monday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .monday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .monday,    hour: 23, minute: 15),

        // Tuesday
        BossSpawn(bosses: [.nouver],        dayOfWeek: .tuesday,   hour: 0,  minute: 15),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .tuesday,   hour: 2,  minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .tuesday,   hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .tuesday,   hour: 9,  minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .tuesday,   hour: 12, minute: 0),
        BossSpawn(bosses: [.quint, .muraka], dayOfWeek: .tuesday,  hour: 14, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .tuesday,   hour: 16, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .tuesday,   hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .tuesday,   hour: 22, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .tuesday,   hour: 23, minute: 15),

        // Wednesday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .wednesday, hour: 0,  minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .wednesday, hour: 2,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .wednesday, hour: 5,  minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .wednesday, hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .wednesday, hour: 12, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .wednesday, hour: 16, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .wednesday, hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .wednesday, hour: 22, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .wednesday, hour: 23, minute: 15),

        // Thursday
        BossSpawn(bosses: [.kutum],         dayOfWeek: .thursday,  hour: 0,  minute: 15),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .thursday,  hour: 2,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .thursday,  hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .thursday,  hour: 9,  minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .thursday,  hour: 12, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .thursday,  hour: 16, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .thursday,  hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .thursday,  hour: 22, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .thursday,  hour: 23, minute: 15),

        // Friday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .friday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .friday,    hour: 2,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .friday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .friday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .friday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.quint, .muraka], dayOfWeek: .friday,   hour: 14, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .friday,    hour: 16, minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .friday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .friday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .friday,    hour: 23, minute: 15),

        // Saturday
        BossSpawn(bosses: [.kutum],         dayOfWeek: .saturday,  hour: 0,  minute: 15),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .saturday,  hour: 2,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .saturday,  hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .saturday,  hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .saturday,  hour: 12, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .saturday,  hour: 16, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .saturday,  hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .saturday,  hour: 22, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .saturday,  hour: 23, minute: 15),
    ]

    // MARK: - EU Schedule (Times in UTC)

    static let euSchedule: [BossSpawn] = [
        // Sunday
        BossSpawn(bosses: [.nouver],        dayOfWeek: .sunday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .sunday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .sunday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .sunday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .sunday,    hour: 14, minute: 0),
        BossSpawn(bosses: [.vell],          dayOfWeek: .sunday,    hour: 16, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .sunday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .sunday,    hour: 19, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .sunday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .sunday,    hour: 23, minute: 15),

        // Monday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .monday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .monday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .monday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .monday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .monday,    hour: 16, minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .monday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .monday,    hour: 19, minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .monday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .monday,    hour: 23, minute: 15),

        // Tuesday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .tuesday,   hour: 0,  minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .tuesday,   hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .tuesday,   hour: 9,  minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .tuesday,   hour: 12, minute: 0),
        BossSpawn(bosses: [.quint, .muraka], dayOfWeek: .tuesday,  hour: 14, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .tuesday,   hour: 16, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .tuesday,   hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .tuesday,   hour: 19, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .tuesday,   hour: 22, minute: 15),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .tuesday,   hour: 23, minute: 15),

        // Wednesday
        BossSpawn(bosses: [.nouver],        dayOfWeek: .wednesday, hour: 0,  minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .wednesday, hour: 5,  minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .wednesday, hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .wednesday, hour: 12, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .wednesday, hour: 16, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .wednesday, hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .wednesday, hour: 19, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .wednesday, hour: 22, minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .wednesday, hour: 23, minute: 15),

        // Thursday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .thursday,  hour: 0,  minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .thursday,  hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .thursday,  hour: 9,  minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .thursday,  hour: 12, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .thursday,  hour: 16, minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .thursday,  hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .thursday,  hour: 19, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .thursday,  hour: 22, minute: 15),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .thursday,  hour: 23, minute: 15),

        // Friday
        BossSpawn(bosses: [.kutum],         dayOfWeek: .friday,    hour: 0,  minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .friday,    hour: 5,  minute: 0),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .friday,    hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .friday,    hour: 12, minute: 0),
        BossSpawn(bosses: [.quint, .muraka], dayOfWeek: .friday,   hour: 14, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .friday,    hour: 16, minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .friday,    hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .friday,    hour: 19, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .friday,    hour: 22, minute: 15),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .friday,    hour: 23, minute: 15),

        // Saturday
        BossSpawn(bosses: [.karanda],       dayOfWeek: .saturday,  hour: 0,  minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .saturday,  hour: 5,  minute: 0),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .saturday,  hour: 9,  minute: 0),
        BossSpawn(bosses: [.offinTett],     dayOfWeek: .saturday,  hour: 12, minute: 0),
        BossSpawn(bosses: [.kutum],         dayOfWeek: .saturday,  hour: 16, minute: 0),
        BossSpawn(bosses: [.karanda],       dayOfWeek: .saturday,  hour: 19, minute: 0),
        BossSpawn(bosses: [.garmoth],       dayOfWeek: .saturday,  hour: 19, minute: 15),
        BossSpawn(bosses: [.nouver],        dayOfWeek: .saturday,  hour: 22, minute: 15),
        BossSpawn(bosses: [.kzarka],        dayOfWeek: .saturday,  hour: 23, minute: 15),
    ]

    // MARK: - SEA Schedule (Times in SGT / Asia/Singapore)
    // Placeholder: mirrors NA schedule structure. Update with actual SEA times.

    static let seaSchedule: [BossSpawn] = naSchedule

    // MARK: - SA Schedule (Times in BRT / America/Sao_Paulo)
    // Placeholder: mirrors NA schedule structure. Update with actual SA times.

    static let saSchedule: [BossSpawn] = naSchedule
}
