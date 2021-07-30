import SwiftUI

@main
struct CodingChallengeApp: App {
    let api = ShiftsAPI(agent: Agent())
    var body: some Scene {
        WindowGroup {
            ShiftsView(viewModel: ShiftsViewModel(api: api) )
        }
    }
}
