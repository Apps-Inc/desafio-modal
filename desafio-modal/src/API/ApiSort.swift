import Foundation

enum ApiSort: Queriable {
    case stars
    case forks
    case helpWantedIssues
    case updated

    var queryParam: String {
        switch self {
        case .stars: return "stars"
        case .forks: return "forks"
        case .helpWantedIssues: return "help-wanted-issues"
        case .updated: return "updated"
        }
    }
}
