import Foundation
import Observation

/// Loads the bundled mental-model library and derives the "model of the day."
@Observable
final class ContentStore {
    private(set) var models: [MentalModel] = []

    init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "models", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            assertionFailure("models.json not found in bundle")
            return
        }
        do {
            models = try JSONDecoder().decode([MentalModel].self, from: data)
        } catch {
            assertionFailure("Failed to decode models.json: \(error)")
        }
    }

    func models(in discipline: Discipline) -> [MentalModel] {
        models.filter { $0.discipline == discipline }
    }

    /// Deterministic daily model so it's stable across the day & relaunches.
    var modelOfTheDay: MentalModel? {
        guard !models.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0
        return models[day % models.count]
    }

    func model(id: String) -> MentalModel? { models.first { $0.id == id } }
}
