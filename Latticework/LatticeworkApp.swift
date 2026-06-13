import SwiftUI
import SwiftData
import LatticeworkKit

@main
struct LatticeworkApp: App {
    let container: ModelContainer
    @State private var app: AppState

    init() {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: StoredProgress.self, StoredDecision.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        self.container = container
        _app = State(initialValue: AppState(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(app)
                .tint(Theme.ink)
        }
        .modelContainer(container)
    }
}

/// Composition root. Builds the kit's services from the SwiftData context and
/// holds the app-level stores. Views read this from the environment.
@MainActor
@Observable
final class AppState {
    let content = ContentStore()
    let streaks = StreakStore()
    let progress: ProgressService
    let journal: DecisionJournal

    init(context: ModelContext) {
        self.progress = ProgressService(store: SwiftDataProgressStore(context))
        self.journal = DecisionJournal(store: SwiftDataDecisionStore(context))
    }

    // Convenience pass-throughs for views.
    func status(for id: String) -> ModelStatus { progress.status(for: id) }
    func recordDrill(modelID id: String) { progress.recordDrill(modelID: id) }
    func learningCount() -> Int { progress.learningCount(in: content.all.map(\.id)) }
    func masteredCount() -> Int { progress.masteredCount(in: content.all.map(\.id)) }
}
