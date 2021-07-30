import XCTest
import SnapshotTesting
import SwiftUI

@testable import CodingChallenge

final class ShiftDetailsViewSnapshotTest: XCTestCase {
    func testDefaultAppearance() {
        let view = ShiftDetailsView(item: .fixture).referenceFrame(for: CGSize(width: 300, height: 500))

        assertSnapshot(
            matching: view,
            as: .image()
        )
    }
}

private extension SwiftUI.View {
    func referenceFrame(for size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}
