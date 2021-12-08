import Foundation

typealias RepositoriesResponseDto = [RepositoryResponseDto]

extension DataMockable where Self == [RepositoryResponseDto] {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repositories-response-mock",
            withExtension: "json"
        )!))!
    }
}
