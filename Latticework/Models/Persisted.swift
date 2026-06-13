import Foundation
import SwiftData

/// Per-model learning progress (SwiftData, iCloud-syncable).
@Model
final class ModelProgress {
    @Attribute(.unique) var modelID: String
    var status: String          // "new" | "learning" | "mastered"
    var lastReviewed: Date?
    var drillsCompleted: Int

    init(modelID: String, status: String = "new", lastReviewed: Date? = nil, drillsCompleted: Int = 0) {
        self.modelID = modelID
        self.status = status
        self.lastReviewed = lastReviewed
        self.drillsCompleted = drillsCompleted
    }
}

/// A logged real-world decision — the retention "killer feature."
@Model
final class DecisionEntry {
    var id: UUID
    var title: String
    var decision: String
    var modelsUsed: [String]    // model IDs / titles applied
    var expectedOutcome: String
    var confidence: Int         // 0–100
    var createdAt: Date
    var reviewedOutcome: String?
    var reviewedAt: Date?

    init(title: String, decision: String, modelsUsed: [String] = [], expectedOutcome: String = "", confidence: Int = 50) {
        self.id = UUID()
        self.title = title
        self.decision = decision
        self.modelsUsed = modelsUsed
        self.expectedOutcome = expectedOutcome
        self.confidence = confidence
        self.createdAt = .now
    }
}
