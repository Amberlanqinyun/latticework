import SwiftUI

struct RootTabView: View {
    @State private var content = ContentStore()
    @State private var streaks = StreakStore()

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            LibraryView()
                .tabItem { Label("Library", systemImage: "square.grid.2x2") }

            DrillsView()
                .tabItem { Label("Drills", systemImage: "target") }

            JournalView()
                .tabItem { Label("Journal", systemImage: "book.closed") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .environment(content)
        .environment(streaks)
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: [ModelProgress.self, DecisionEntry.self], inMemory: true)
}
