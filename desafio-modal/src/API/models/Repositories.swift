import Foundation

struct Repository {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String
    let url: String

    init(_ dto: RepositoryResponseDto) {
        id = dto.id
        name = dto.name
        fullName = dto.fullName
        htmlUrl = dto.htmlUrl
        url = dto.url
    }
}

typealias Repositories = [Repository]

extension Repositories {
    init(_ dto: RepositoriesResponseDto) {
        self = dto.map(Repository.init)
    }
}
