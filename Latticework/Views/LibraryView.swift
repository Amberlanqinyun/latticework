import SwiftUI
import LatticeworkKit

struct LibraryView: View {
    @Environment(AppState.self) private var app
    @State private var search = ""

    private var filtered: [MentalModel] {
        guard !search.isEmpty else { return [] }
        return app.content.all.filter {
            $0.title.localizedCaseInsensitiveContains(search) ||
            $0.quote.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    TitleHeader(glyph: .library, title: "Library")

                    HStack(spacing: 10) {
                        AppIcon(.search, size: 17).foregroundStyle(Theme.faint)
                        TextField("Search models & quotes", text: $search)
                            .font(Theme.font(14)).textFieldStyle(.plain)
                    }
                    .padding(.horizontal, 18).padding(.vertical, 15)
                    .background(Theme.bg, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.line, lineWidth: 1))

                    if search.isEmpty {
                        ForEach(app.content.disciplinesPresent()) { d in
                            SectionLabel(glyph: .discipline(d.rawValue), text: d.rawValue)
                            modelGroup(app.content.models(in: d))
                        }
                    } else {
                        SectionLabel(text: "Results")
                        modelGroup(filtered)
                    }
                }
                .padding(20)
            }
            .background(Theme.page)
            .navigationDestination(for: String.self) { id in ModelDetailView(modelID: id) }
        }
    }

    private func modelGroup(_ models: [MentalModel]) -> some View {
        Block {
            VStack(spacing: 0) {
                ForEach(Array(models.enumerated()), id: \.element.id) { idx, m in
                    if idx > 0 { Divider().background(Theme.line) }
                    NavigationLink(value: m.id) {
                        HStack(spacing: 13) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Theme.tag)
                                AppIcon(.discipline(m.discipline.rawValue), size: 17).foregroundStyle(Theme.ink)
                            }
                            .frame(width: 30, height: 30)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(m.title).font(Theme.font(14.5, .semibold)).foregroundStyle(Theme.ink)
                                Text(statusText(m)).font(Theme.font(11.5)).foregroundStyle(Theme.faint)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 11)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func statusText(_ m: MentalModel) -> String {
        switch app.status(for: m.id) {
        case .mastered: return "\(m.discipline.rawValue) · Mastered"
        case .learning: return "\(m.discipline.rawValue) · Learning"
        case .new: return m.discipline.rawValue
        }
    }
}
