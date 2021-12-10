import Foundation

struct RepositoryDetails {
    let id: Int
    let name: String
    let fullName: String
    let createdAt: Date
    let forks: Int
    let watchers: Int
    let stargazersCount: Int
    let avatarUrl: URL?

    init?(_ dto: RepositoryDetailsResponseDto) {
        let dateFormatter = ISO8601DateFormatter()
        guard let createdDate = dateFormatter.date(from: dto.createdAt) else {
            return nil
        }

        id = dto.id
        name = dto.name
        fullName = dto.fullName
        createdAt = createdDate
        forks = dto.forks
        watchers = dto.watchers
        stargazersCount = dto.stargazersCount
        avatarUrl = URL(string: dto.owner.avatarUrl ?? "")
    }
}
