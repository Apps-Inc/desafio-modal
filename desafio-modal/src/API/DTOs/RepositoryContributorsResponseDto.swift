import Foundation

typealias RepositoryContributorsResponseDto = [RepositoryContributorResponseDto]

extension DataMockable where Self == RepositoryContributorsResponseDto {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-contributors-response-mock",
            withExtension: "json"
        )!))!
    }
}
