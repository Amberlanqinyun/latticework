import SwiftUI
import SwiftData

@main
struct LatticeworkApp: App {
    // SwiftData container for user-generated, persisted data.
    let container: ModelContainer = {
        do {
            return try ModelContainer(for: ModelProgress.self, DecisionEntry.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .tint(Theme.accent)
        }
        .modelContainer(container)
    }
}
