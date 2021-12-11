import Foundation

// Usar os dados retornados por /search/repositories ao invés dos que o /repo
// retorna, pois parece ser o denominador comum entre eles.
struct RepositoryDetailsResponseDto {
    let id: Int
    let name: String
    let fullName: String
    let createdAt: String
    let forks: Int
    let watchers: Int
    let stargazersCount: Int
    let owner: OwnerDto

    struct OwnerDto: Decodable {
        let avatarUrl: String?
    }

}

extension RepositoryDetailsResponseDto: DataMockable {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-details-response-mock",
            withExtension: "json"
        )!))!
    }
}
