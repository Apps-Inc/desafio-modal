import Foundation

// Usar os dados retornados por /search/repositories ao invés dos que o /repo
// retorna, pois parece ser o denominador comum entre eles.
struct RepositoryDetailsResponseDto {
    let id: Int
    let createdAt: String

    let stargazersCount: Int
}

extension RepositoryDetailsResponseDto: DataMockable {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-details-response-mock",
            withExtension: "json"
        )!))!
    }
}
