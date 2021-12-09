import Foundation

struct GitHubSearchResposeDto {
    let totalCount: Int
    let items: [RepositoryDetailsResponseDto]
}

extension GitHubSearchResposeDto: DataMockable {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "github-search-response-mock",
            withExtension: ".json"
        )!))!
    }
}
