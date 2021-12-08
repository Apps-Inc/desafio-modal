import Foundation

struct RepositoryResponseDto: Decodable {
    let id: Int
    let name: String
    let htmlUrl: String
    let url: String // API url
}
