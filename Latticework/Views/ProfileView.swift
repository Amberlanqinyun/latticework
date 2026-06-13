import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(StreakStore.self) private var streaks
    @Environment(ContentStore.self) private var content
    @Query private var progress: [ModelProgress]

    private var mastered: Int { progress.filter { $0.status == "mastered" }.count }
    private var learning: Int { progress.filter { $0.status == "learning" }.count }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    stat("Current streak", "\(streaks.count) days", "flame.fill")
                    stat("Models learning", "\(learning)", "book")
                    stat("Models mastered", "\(mastered) / \(content.models.count)", "checkmark.seal.fill")
                }
                Section("Subscription") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Latticework Premium").font(.headline)
                            Text("Full library, advanced drills, iCloud sync")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Upgrade") { }
                            .buttonStyle(.borderedProminent)
                            .tint(Theme.accent)
                    }
                }
                Section("About") {
                    Text("Built on the worldly wisdom of Charlie Munger. Quotes are short, attributed excerpts used for educational commentary.")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }

    private func stat(_ title: String, _ value: String, _ symbol: String) -> some View {
        HStack {
            Label(title, systemImage: symbol).foregroundStyle(Theme.accent)
            Spacer()
            Text(value).font(.body.weight(.semibold))
        }
    }
}
