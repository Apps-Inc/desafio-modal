import Foundation

typealias RepositoryBranchesResponseDto = [RepositoryBranchResponseDto]

extension DataMockable where Self == RepositoryBranchesResponseDto {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-branches-response-mock",
            withExtension: "json"
        )!))!
    }
}
