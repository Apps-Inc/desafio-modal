import Foundation

struct RepositoryDetailsResponseDto {
    let id: Int
    let createdAt: String

    let stargazersCount: Int
    let watchersCount: Int
    let subscribersCount: Int
}

extension RepositoryDetailsResponseDto: DataMockable {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-details-response-mock",
            withExtension: "json"
        )!))!
    }
}
