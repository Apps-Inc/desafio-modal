import Foundation

enum FilterButton: String, CaseIterable {
    case star = "Estrelas"
    case followers = "Seguidores"
    case date = "Data"
    case descending = "Decrescente"

    var name: String {
        self.rawValue
    }
}
