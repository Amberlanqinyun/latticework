import Foundation

/// Loads and queries the bundled mental-model library.
/// Pure value logic — the model-of-the-day selection is deterministic, no RNG, no I/O.
public struct ContentLibrary: Sendable {
    public let all: [MentalModel]

    public init(models: [MentalModel]) {
        self.all = models
    }

    /// Models in a discipline, preserving source order.
    public func models(in discipline: Discipline) -> [MentalModel] {
        all.filter { $0.discipline == discipline }
    }

    public func model(id: String) -> MentalModel? {
        all.first { $0.id == id }
    }

    /// Disciplines that actually have at least one model, in canonical enum order.
    public func disciplinesPresent() -> [Discipline] {
        Discipline.allCases.filter { d in all.contains { $0.discipline == d } }
    }

    /// Deterministic model of the day: stable for a given calendar day, no randomness.
    /// Returns nil only when the library is empty.
    public func modelOfTheDay(on date: Date, calendar: Calendar = .current) -> MentalModel? {
        guard !all.isEmpty else { return nil }
        let ordinal = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        let index = ((ordinal % all.count) + all.count) % all.count
        return all[index]
    }

    // MARK: - Bundled loading

    public enum LoadError: Error, Equatable { case resourceMissing, decodeFailed(String) }

    /// Loads `models.json` from the package resource bundle.
    public static func bundled() throws -> ContentLibrary {
        try load(from: .module)
    }

    /// Loads `models.json` from a specific bundle (e.g. the app bundle).
    public static func load(from bundle: Bundle) throws -> ContentLibrary {
        guard let url = bundle.url(forResource: "models", withExtension: "json") else {
            throw LoadError.resourceMissing
        }
        let data = try Data(contentsOf: url)
        return try decode(data)
    }

    /// Decodes a library from raw JSON data.
    public static func decode(_ data: Data) throws -> ContentLibrary {
        do {
            let models = try JSONDecoder().decode([MentalModel].self, from: data)
            return ContentLibrary(models: models)
        } catch {
            throw LoadError.decodeFailed(String(describing: error))
        }
    }
}
