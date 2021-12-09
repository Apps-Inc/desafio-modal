import Foundation

enum FilterButton: CaseIterable, Hashable {
    static var allCases: [FilterButton] = [.star, .followers, .date, .order(label: "decrecente")]

    case star
    case followers
    case date
    case order(label: String)

    var name: String {
        switch self {
        case .star:
            return "Estrelas"
        case .followers:
            return "Seguidores"
        case .date:
            return  "Data"
        case .order(let label):
            return label
        }
    }
}
