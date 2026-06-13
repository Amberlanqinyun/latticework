import SwiftUI
import LatticeworkKit

enum Tab: CaseIterable {
    case today, library, drills, journal, profile
    var title: String {
        switch self {
        case .today: return "Today"; case .library: return "Library"
        case .drills: return "Drills"; case .journal: return "Journal"; case .profile: return "Profile"
        }
    }
    var glyph: AppIcon.Glyph {
        switch self {
        case .today: return .today; case .library: return .library
        case .drills: return .drills; case .journal: return .journal; case .profile: return .profile
        }
    }
}

struct RootTabView: View {
    @State private var tab: Tab = .today

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case .today: TodayView()
                case .library: LibraryView()
                case .drills: DrillsView()
                case .journal: JournalView()
                case .profile: ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selection: $tab)
        }
        .background(Theme.page)
    }
}

private struct CustomTabBar: View {
    @Binding var selection: Tab

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { t in
                Button {
                    selection = t
                    UISelectionFeedbackGenerator().selectionChanged()
                } label: {
                    VStack(spacing: 6) {
                        AppIcon(t.glyph, size: 22)
                        Text(t.title).font(Theme.font(10, .semibold))
                    }
                    .foregroundStyle(selection == t ? Theme.ink : Theme.faint)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 2)
        .background(.ultraThinMaterial)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.line), alignment: .top)
    }
}
