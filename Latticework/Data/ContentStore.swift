import Foundation
import Observation
import LatticeworkKit

/// App-level wrapper around the kit's `ContentLibrary`. Loads the bundled
/// `models.json` from the app bundle and exposes it to the views.
@Observable
final class ContentStore {
    let library: ContentLibrary

    init() {
        if let lib = try? ContentLibrary.load(from: .main) {
            library = lib
        } else if let lib = try? ContentLibrary.bundled() {
            library = lib          // fallback to the package resource bundle
        } else {
            library = ContentLibrary(models: [])
        }
    }

    var all: [MentalModel] { library.all }
    func models(in d: Discipline) -> [MentalModel] { library.models(in: d) }
    func model(id: String) -> MentalModel? { library.model(id: id) }
    func disciplinesPresent() -> [Discipline] { library.disciplinesPresent() }
    var modelOfTheDay: MentalModel? { library.modelOfTheDay(on: .now) }
}
