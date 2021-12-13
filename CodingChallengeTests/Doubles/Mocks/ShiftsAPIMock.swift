import XCTest
import Combine

@testable import CodingChallenge

final class ShiftsAPIMock: ShiftsAPIProtocol {
    var capturedWeek: Int?

    var result: AnyPublisher<ShiftsResponse, Error>!
    func shifts(week: Int) -> AnyPublisher<ShiftsResponse, Error> {
        capturedWeek = week
        return result
    }

}
