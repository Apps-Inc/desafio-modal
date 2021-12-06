import Foundation

typealias RepositoriesResponseDto = [RepositoryResponseDto]

extension RepositoriesResponseDto: DataMockable {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repositories-response-mock",
            withExtension: "json"
        )!))!
    }
}
