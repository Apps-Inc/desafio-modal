import Foundation

enum ApiOrder: Queriable {
    case ascending
    case descending

    var queryParam: String {
        switch self {
        case .ascending: return "asc"
        case .descending: return "desc"
        }
    }
}
