import Foundation

struct RepositoryDetails {
    let id: Int
    let createdAt: Date

    let stargazersCount: Int

    init?(_ dto: RepositoryDetailsResponseDto) {
        let dateFormatter = ISO8601DateFormatter()
        guard let createdDate = dateFormatter.date(from: dto.createdAt) else {
            return nil
        }

        id = dto.id
        createdAt = createdDate

        stargazersCount = dto.stargazersCount
    }
}
