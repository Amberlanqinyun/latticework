import SwiftUI

struct LibraryView: View {
    @Environment(ContentStore.self) private var content
    @State private var search = ""

    private var filtered: [MentalModel] {
        guard !search.isEmpty else { return content.models }
        return content.models.filter {
            $0.title.localizedCaseInsensitiveContains(search) ||
            $0.quote.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if search.isEmpty {
                    ForEach(Discipline.allCases) { discipline in
                        let models = content.models(in: discipline)
                        if !models.isEmpty {
                            Section(discipline.rawValue) {
                                ForEach(models) { ModelRow(model: $0) }
                            }
                        }
                    }
                } else {
                    Section("Results") {
                        ForEach(filtered) { ModelRow(model: $0) }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Library")
            .searchable(text: $search, prompt: "Search models & quotes")
            .navigationDestination(for: MentalModel.self) { ModelDetailView(model: $0) }
        }
    }
}

struct ModelRow: View {
    let model: MentalModel

    var body: some View {
        NavigationLink(value: model) {
            HStack(spacing: 14) {
                Image(systemName: model.discipline.symbol)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(model.title).font(.body.weight(.medium))
                    Text(model.discipline.rawValue)
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}
