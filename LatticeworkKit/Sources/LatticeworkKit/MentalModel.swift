import Foundation

/// A discipline groups related mental models (Munger's "latticework").
/// Raw values are the canonical display names used in bundled content.
public enum Discipline: String, Codable, CaseIterable, Identifiable, Sendable {
    case psychology = "Psychology"
    case economics = "Economics"
    case math = "Math & Probability"
    case physics = "Physics & Engineering"
    case biology = "Biology"
    case inversion = "Inversion"

    public var id: String { rawValue }

    /// Name of the bespoke icon for this discipline (see skill `icons.md`).
    public var iconName: String {
        switch self {
        case .psychology: return "psychology"
        case .economics: return "economics"
        case .math: return "math"
        case .physics: return "shield"
        case .biology: return "people"
        case .inversion: return "inversion"
        }
    }
}

/// A single mental model — the bundled, read-only content unit.
public struct MentalModel: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let discipline: Discipline
    public let quote: String
    public let definition: String
    public let example: String
    public let whenToUse: String
    public let trap: String
    public let drill: Drill

    public init(id: String, title: String, discipline: Discipline, quote: String,
                definition: String, example: String, whenToUse: String, trap: String, drill: Drill) {
        self.id = id; self.title = title; self.discipline = discipline; self.quote = quote
        self.definition = definition; self.example = example; self.whenToUse = whenToUse
        self.trap = trap; self.drill = drill
    }

    /// A scenario-based recall question attached to a model.
    public struct Drill: Codable, Equatable, Sendable {
        public let scenario: String
        public let options: [String]
        public let correctIndex: Int
        public let explanation: String

        public init(scenario: String, options: [String], correctIndex: Int, explanation: String) {
            self.scenario = scenario; self.options = options
            self.correctIndex = correctIndex; self.explanation = explanation
        }
    }
}
