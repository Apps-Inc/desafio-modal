import Foundation

struct RepositoryReleaseResponseDto: Decodable {
    let tagName: String
}

typealias RepositoryReleasesResponseDto = [RepositoryReleaseResponseDto]

extension DataMockable where Self == RepositoryReleasesResponseDto {
    static var dataMock: Data {
        (try? Data(contentsOf: Bundle.main.url(
            forResource: "repository-releases-response-mock",
            withExtension: "json"
        )!))!
    }
}
