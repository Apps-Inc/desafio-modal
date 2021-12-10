import Foundation

enum FilterButton: String, CaseIterable, Hashable {

    case star = "Estrelas"
    case followers = "Seguidores"
    case date = "Data"
    case order = "ordem"

    var name: String {
        return self.rawValue
    }
}
