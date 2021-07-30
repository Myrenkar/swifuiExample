@testable import CodingChallenge
import Foundation

extension ShiftDTO {
    static var fixture: ShiftDTO {
        return ShiftDTO(shiftId: 111,
                        startTime: Date(),
                        endTime: Date(),
                        covid: false,
                        shiftKind: "fixed_key",
                        facilityType: ShiftFacilityDetails(name: "fixture_name", color: "#FFFFFF"),
                        skill: ShiftFacilityDetails(name: "Fixture_Name", color: "#FAFAFA"),
                        localizedSpecialty: LocalizedSpeciality(name: "fixture_bane",
                                                                specialty: ShiftFacilityDetails(name: "fixture_+name", color: "#fafefa")))
    }
}
