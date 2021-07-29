import SwiftUI

@main
struct CodingChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ShiftsView(viewModel: ShiftsViewModel())
        }
    }
}
