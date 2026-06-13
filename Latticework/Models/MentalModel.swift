import Foundation

/// A discipline groups related mental models (Munger's "latticework").
enum Discipline: String, Codable, CaseIterable, Identifiable {
    case psychology = "Psychology"
    case economics = "Economics"
    case math = "Math & Probability"
    case physics = "Physics & Engineering"
    case biology = "Biology"
    case inversion = "Inversion"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .psychology: return "brain"
        case .economics: return "chart.line.uptrend.xyaxis"
        case .math: return "function"
        case .physics: return "atom"
        case .biology: return "leaf"
        case .inversion: return "arrow.triangle.2.circlepath"
        }
    }
}

/// A single mental model — the content unit. Loaded from bundled JSON.
struct MentalModel: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let discipline: Discipline
    let quote: String          // short, attributed Munger quote
    let definition: String     // original explanation
    let example: String        // vivid real-world example
    let whenToUse: String
    let trap: String           // the misjudgment it prevents
    let drill: Drill

    struct Drill: Codable, Hashable {
        let scenario: String
        let options: [String]
        let correctIndex: Int
        let explanation: String
    }
}
