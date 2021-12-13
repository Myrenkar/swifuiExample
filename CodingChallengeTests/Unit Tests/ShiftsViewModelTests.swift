import XCTest

@testable import CodingChallenge

final class ShiftsViewModelTests: XCTestCase {

    var apiMock: ShiftsAPIMock!
    var sut: ShiftsViewModel!

    override func setUp() {
        super.setUp()

        apiMock = ShiftsAPIMock()
        sut = ShiftsViewModel(api: apiMock)
    }

    override func tearDown() {
        sut = nil
        apiMock = nil

        super.tearDown()
    }

    func testWhenStateIsInitial() {
        // Arrange

        let expectation = XCTestExpectation(description: "Initial state")

        sut.state = .loading

        // Act

        waitForExpectations(timeout: 3)

        // Assert

        XCTAssertNotNil(apiMock.capturedWeek)
    }

}
