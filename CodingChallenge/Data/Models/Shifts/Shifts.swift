import Foundation

struct ShiftsDTO: Codable {
    let date: String
    let shifts: [ShiftDTO]
}

struct ShiftDTO: Codable {
    let shiftId: Int
    let startTime: Date
    let endTime: Date
    let covid: Bool
    let shiftKind: String
    let facilityType: ShiftFacilityDetails
    let skill: ShiftFacilityDetails
    let localizedSpecialty: LocalizedSpeciality

    struct ShiftFacilityDetails: Codable {
        let name: String
        let color: String
    }

    struct LocalizedSpeciality: Codable {
        let name: String
        let specialty: ShiftFacilityDetails
    }
}

struct ShiftsResponse: Codable {
    let data: [ShiftsDTO]
}
